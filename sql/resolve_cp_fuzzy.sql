-- ------------------------------------------------------------
--  Resolve county_parish
-- ------------------------------------------------------------

--
-- Alternate names - simple wildcard match
-- Only if query returns exactly one result
-- 
UPDATE user_data u
SET 
county_parish_id=cp_altname.county_parish_id,
county_parish=cp_altname.county_parish_std,
match_method_county_parish='wildcard alt name'
FROM (
SELECT a.id, COUNT(DISTINCT b.county_parish_id)
FROM user_data a JOIN county_parish b 
ON a.country_id=b.country_id AND a.state_province_id=b.state_province_id
JOIN county_parish_name c
ON b.county_parish_id=c.county_parish_id
WHERE a.job=:'job' 
AND a.county_parish_id IS NULL AND a.match_status IS NULL
AND 
(
c.county_parish_name LIKE  '%'  || a.county_parish_verbatim || '%' OR 
a.county_parish_verbatim LIKE '%'  || c.county_parish_name || '%'
) 
AND a.county_parish_verbatim IS NOT NULL AND a.county_parish_verbatim<>''
GROUP BY a.id
HAVING COUNT(DISTINCT b.county_parish_id)=1
) cp_uniq -- IDs of user-submitted county_verbatim returning one county only
JOIN 
(
SELECT a.id, b.country_id, b.state_province_id, b.county_parish_id, b.county_parish_std
FROM user_data a JOIN county_parish b 
ON a.country_id=b.country_id AND a.state_province_id=b.state_province_id
JOIN county_parish_name c
ON b.county_parish_id=c.county_parish_id
WHERE a.job=:'job' 
AND a.county_parish_id IS NULL AND a.match_status IS NULL
AND 
(
c.county_parish_name LIKE  '%'  || a.county_parish_verbatim || '%' OR 
a.county_parish_verbatim LIKE '%'  || c.county_parish_name || '%'
) 
AND a.county_parish_verbatim IS NOT NULL AND a.county_parish_verbatim<>''
) AS cp_altname -- Retrieves standard id and name for match alt name
ON cp_uniq.id=cp_altname.id -- Join ensures only unambiguous results used
WHERE u.job=:'job' 
AND u.county_parish_id IS NULL AND u.match_status IS NULL
AND u.id=cp_altname.id 
AND TRIM(u.county_parish_verbatim)<>''  -- Can match to anything so filter
AND u.county_parish_verbatim NOT LIKE '%\_%'  -- Filter underscores (=wildcard)
AND u.county_parish_verbatim<>'-'	-- Filter lone hyphen, matches any hyphenated name
AND LENGTH(u.county_parish_verbatim)>3  -- Reduce spurious matches, esp. to ISO codes
;

-- standard name
UPDATE user_data a
SET 
county_parish_id=fzy.county_parish_id,
county_parish=fzy.county_parish_std,
match_method_county_parish='fuzzy standard name',
match_score_county_parish=fzy.similarity
FROM 
(
SELECT
q.county_parish_verbatim,
p.county_parish,
p.country_id,
p.state_province_id,
p.county_parish_id,
p.county_parish_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_id,
county_parish_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_id,
a.county_parish_verbatim,
similarity(a.county_parish_verbatim,b.county_parish) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NOT NULL AND county_parish_id IS NULL AND county_parish_verbatim IS NOT NULL AND county_parish_verbatim<>''
) a,
(
SELECT DISTINCT country_id, state_province_id, county_parish FROM county_parish
) b
WHERE a.country_id=b.country_id AND a.state_province_id=b.state_province_id
) x
GROUP BY country_id, state_province_id, county_parish_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_id,
a.county_parish_verbatim,
b.county_parish_id,
b.county_parish,
b.county_parish_std,
similarity(a.county_parish_verbatim,b.county_parish) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NOT NULL AND county_parish_id IS NULL AND county_parish_verbatim IS NOT NULL AND county_parish_verbatim<>''
) a,
(
SELECT DISTINCT country_id, state_province_id, county_parish_id, county_parish, county_parish_std FROM county_parish
) b
WHERE a.country_id=b.country_id AND a.state_province_id=b.state_province_id
) p
ON q.county_parish_verbatim=p.county_parish_verbatim
AND q.country_id=p.country_id
AND q.state_province_id=p.state_province_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.county_parish_verbatim=fzy.county_parish_verbatim
AND a.country_id=fzy.country_id
AND a.state_province_id=fzy.state_province_id
AND a.county_parish_id IS NULL AND match_method_county_parish IS NULL 
;

-- standard ascii name
UPDATE user_data a
SET 
county_parish_id=fzy.county_parish_id,
county_parish=fzy.county_parish_std,
match_method_county_parish='fuzzy ascii name',
match_score_county_parish=fzy.similarity
FROM 
(
SELECT
q.county_parish_verbatim,
p.county_parish_ascii,
p.country_id,
p.state_province_id,
p.county_parish_id,
p.county_parish_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_id,
county_parish_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_id,
a.county_parish_verbatim,
similarity(a.county_parish_verbatim,b.county_parish_ascii) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NOT NULL AND county_parish_id IS NULL AND county_parish_verbatim IS NOT NULL AND county_parish_verbatim<>''
) a,
(
SELECT DISTINCT country_id, state_province_id, county_parish_ascii FROM county_parish
) b
WHERE a.country_id=b.country_id AND a.state_province_id=b.state_province_id
) x
GROUP BY country_id, state_province_id, county_parish_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_id,
a.county_parish_verbatim,
b.county_parish_id,
b.county_parish_ascii,
b.county_parish_std,
similarity(a.county_parish_verbatim,b.county_parish_ascii) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NOT NULL AND county_parish_id IS NULL AND county_parish_verbatim IS NOT NULL AND county_parish_verbatim<>''
) a,
(
SELECT DISTINCT country_id, state_province_id, county_parish_id, county_parish_ascii, county_parish_std FROM county_parish
) b
WHERE a.country_id=b.country_id AND a.state_province_id=b.state_province_id
) p
ON q.county_parish_verbatim=p.county_parish_verbatim
AND q.country_id=p.country_id
AND q.state_province_id=p.state_province_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.county_parish_verbatim=fzy.county_parish_verbatim
AND a.country_id=fzy.country_id
AND a.state_province_id=fzy.state_province_id
AND a.county_parish_id IS NULL AND match_method_county_parish IS NULL 
;

-- short ascii name
UPDATE user_data a
SET 
county_parish_id=fzy.county_parish_id,
county_parish=fzy.county_parish_std,
match_method_county_parish='fuzzy ascii short name',
match_score_county_parish=fzy.similarity
FROM 
(
SELECT
q.county_parish_verbatim,
p.county_parish_std,
p.country_id,
p.state_province_id,
p.county_parish_id,
p.similarity
FROM 
(
SELECT
country_id,
state_province_id,
county_parish_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_id,
a.county_parish_verbatim,
similarity(a.county_parish_verbatim,b.county_parish_std) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NOT NULL AND county_parish_id IS NULL AND county_parish_verbatim IS NOT NULL AND county_parish_verbatim<>''
) a,
(
SELECT DISTINCT country_id, state_province_id, county_parish_std FROM county_parish
) b
WHERE a.country_id=b.country_id AND a.state_province_id=b.state_province_id
) x
GROUP BY country_id, state_province_id, county_parish_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_id,
a.county_parish_verbatim,
b.county_parish_id,
b.county_parish_std,
similarity(a.county_parish_verbatim,b.county_parish_std) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NOT NULL AND county_parish_id IS NULL AND county_parish_verbatim IS NOT NULL AND county_parish_verbatim<>''
) a,
(
SELECT DISTINCT country_id, state_province_id, county_parish_id, county_parish_std FROM county_parish
) b
WHERE a.country_id=b.country_id AND a.state_province_id=b.state_province_id
) p
ON q.county_parish_verbatim=p.county_parish_verbatim
AND q.country_id=p.country_id
AND q.state_province_id=p.state_province_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.county_parish_verbatim=fzy.county_parish_verbatim
AND a.country_id=fzy.country_id
AND a.state_province_id=fzy.state_province_id
AND a.county_parish_id IS NULL AND match_method_county_parish IS NULL 
;

-- alternate name
UPDATE user_data a
SET 
county_parish_id=fzy.county_parish_id,
county_parish=fzy.county_parish_std,
match_method_county_parish='fuzzy alternate name',
match_score_county_parish=fzy.similarity
FROM 
(
SELECT
q.county_parish_verbatim,
p.county_parish_name,
p.country_id,
p.state_province_id,
p.county_parish_id,
p.county_parish_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_id,
county_parish_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_id,
a.county_parish_verbatim,
b.county_parish_std,
similarity(a.county_parish_verbatim,b.county_parish_name) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NOT NULL AND county_parish_id IS NULL AND county_parish_verbatim IS NOT NULL AND county_parish_verbatim<>''
) a,
(
SELECT a.country_id, a.state_province_id, a.county_parish_id, a.county_parish_std, b.county_parish_name FROM county_parish a JOIN county_parish_name b ON a.county_parish_id=b.county_parish_id WHERE name_type='original from geonames'
) b
WHERE a.country_id=b.country_id AND a.state_province_id=b.state_province_id
) x
GROUP BY country_id, state_province_id, county_parish_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_id,
a.county_parish_verbatim,
b.county_parish_name,
b.county_parish_id,
b.county_parish_std,
similarity(a.county_parish_verbatim,b.county_parish_name) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NOT NULL AND county_parish_id IS NULL AND county_parish_verbatim IS NOT NULL AND county_parish_verbatim<>''
) a,
(
SELECT a.country_id, a.state_province_id, a.county_parish_id, a.county_parish_std, b.county_parish_name FROM county_parish a JOIN county_parish_name b ON a.county_parish_id=b.county_parish_id WHERE name_type='original from geonames'
) b
WHERE a.country_id=b.country_id AND a.state_province_id=b.state_province_id
) p
ON q.county_parish_verbatim=p.county_parish_verbatim
AND q.country_id=p.country_id
AND q.state_province_id=p.state_province_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.county_parish_verbatim=fzy.county_parish_verbatim
AND a.country_id=fzy.country_id
AND a.state_province_id=fzy.state_province_id
AND a.county_parish_id IS NULL AND match_method_county_parish IS NULL 
;


--
-- Alternate names - simple wildcard match
-- Only if query returns exactly one result
-- 
UPDATE user_data u
SET 
county_parish_id=cp.county_parish_id,
county_parish=cp.county_parish_std,
match_method_county_parish='wildcard alt verbatim name'
FROM (
SELECT a.id, b.country_id, b.state_province_id, b.county_parish_id, b.county_parish_std, COUNT(DISTINCT b.county_parish_id)
FROM user_data a JOIN county_parish b 
ON a.country_id=b.country_id AND a.state_province_id=b.state_province_id
JOIN county_parish_name c
ON b.county_parish_id=c.county_parish_id
WHERE a.job=:'job' 
AND a.county_parish_id IS NULL AND a.match_status IS NULL
AND 
(
c.county_parish_name LIKE  '%'  || a.county_parish_verbatim_alt || '%' OR 
a.county_parish_verbatim_alt LIKE '%'  || c.county_parish_name || '%'
) 
AND a.county_parish_verbatim_alt IS NOT NULL AND a.county_parish_verbatim_alt<>''
GROUP BY a.id, b.country_id, b.state_province_id, b.county_parish_id, b.county_parish_std
HAVING COUNT(DISTINCT b.county_parish_id)=1
) cp
WHERE u.job=:'job' 
AND u.county_parish_id IS NULL AND u.match_status IS NULL
AND u.id=cp.id 
;
