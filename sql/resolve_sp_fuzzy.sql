-- ------------------------------------------------------------
--  Resolve state_province
-- ------------------------------------------------------------

--
-- Alternate names - simple wildcard match
-- Only if query returns exactly one result
-- 

UPDATE user_data u
SET 
state_province_id=alt.state_province_id,
state_province=alt.state_province_std,
match_method_state_province='wildcard alt name'
FROM (
SELECT a.id, COUNT(DISTINCT b.state_province_id)
FROM user_data a JOIN state_province b 
ON a.country_id=b.country_id
JOIN state_province_name c
ON b.state_province_id=c.state_province_id
WHERE a.job=:'job' 
AND a.state_province_id IS NULL AND match_method_state_province IS NULL 
AND 
(
c.state_province_name LIKE  '%'  || a.state_province_verbatim || '%' OR 
a.state_province_verbatim LIKE '%'  || c.state_province_name || '%'
) 
AND a.state_province_verbatim IS NOT NULL AND a.state_province_verbatim<>''
GROUP BY a.id
HAVING COUNT(DISTINCT b.state_province_id)=1
) AS uniq -- IDs of user-submitted county values returning one CAS only
JOIN 
(
SELECT a.id, b.country_id, b.state_province_id, b.state_province_std
FROM user_data a JOIN state_province b 
ON a.country_id=b.country_id
JOIN state_province_name c
ON b.state_province_id=c.state_province_id
WHERE a.job=:'job' 
AND a.state_province_id IS NULL AND match_method_state_province IS NULL 
AND 
(
c.state_province_name LIKE  '%'  || a.state_province_verbatim || '%' OR 
a.state_province_verbatim LIKE '%'  || c.state_province_name || '%'
) 
AND a.state_province_verbatim IS NOT NULL AND a.state_province_verbatim<>''
) AS alt -- Retrieves standard id and name for submitted alt name
ON uniq.id=alt.id -- Join ensures only unambiguous results used
WHERE u.job=:'job' 
AND u.state_province_id IS NULL AND match_method_state_province IS NULL 
AND u.id=alt.id
AND TRIM(u.state_province_verbatim)<>''  -- Can match to anything so filter
AND u.state_province_verbatim NOT LIKE '%\_%'  -- Filter underscores (=wildcard)
AND u.state_province_verbatim<>'-'	-- Filter lone hyphen, matches any hyphenated name
AND LENGTH(u.state_province_verbatim)>3  -- Reduce spurious matches, esp. to ISO codes
;

-- standard name
UPDATE user_data a
SET 
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy standard name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_verbatim,
similarity(a.state_province_verbatim,b.state_province) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_verbatim,
b.state_province_id,
b.state_province,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province_id, b.state_province, b.state_province_std FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.state_province_verbatim=fzy.state_province_verbatim
AND a.country_id=fzy.country_id
AND a.state_province IS NULL AND match_method_state_province IS NULL 
;

-- standard ascii name
UPDATE user_data a
SET 
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy ascii name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_verbatim,
similarity(a.state_province_verbatim,b.state_province_ascii) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province_id, b.state_province_ascii FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_verbatim,
b.state_province_id,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province_ascii) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province_id, b.state_province_ascii, b.state_province_std FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.state_province_verbatim=fzy.state_province_verbatim
AND a.country_id=fzy.country_id
AND a.state_province IS NULL AND match_method_state_province IS NULL 
;

-- short ascii name
UPDATE user_data a
SET 
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy ascii short name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_verbatim,
similarity(a.state_province_verbatim,b.state_province_std) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province_id, b.state_province_std FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_verbatim,
b.state_province_id,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province_std) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province_id, b.state_province_std FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.state_province_verbatim=fzy.state_province_verbatim
AND a.country_id=fzy.country_id
AND a.state_province IS NULL AND match_method_state_province IS NULL 
;

-- alternate name
UPDATE user_data a
SET 
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy alternate name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_verbatim,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province_name) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT c.country_id, a.state_province_id, state_province_std, state_province_name FROM state_province a JOIN state_province_name b ON a.state_province_id=b.state_province_id JOIN country c ON a.country_id=c.country_id WHERE name_type='original from geonames') b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_verbatim,
b.state_province_id,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province_name) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT c.country_id, a.state_province_id, state_province_std, state_province_name FROM state_province a JOIN state_province_name b ON a.state_province_id=b.state_province_id JOIN country c ON a.country_id=c.country_id WHERE name_type='original from geonames') b
WHERE a.country_id=b.country_id
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.state_province_verbatim=fzy.state_province_verbatim
AND a.country_id=fzy.country_id
AND a.state_province IS NULL AND match_method_state_province IS NULL 
;


--
-- Alternate names - simple wildcard match
-- Matching by alternate (stripped) verbatim state name
-- 

UPDATE user_data u
SET 
state_province_id=sp.state_province_id,
state_province=sp.state_province_std,
match_method_state_province='wildcard alt verbatim name'
FROM (
SELECT a.id, b.country_id, b.state_province_id, b.state_province_std, COUNT(DISTINCT b.state_province_id)
FROM user_data a JOIN state_province b 
ON a.country_id=b.country_id
JOIN state_province_name c
ON b.state_province_id=c.state_province_id
WHERE a.job=:'job' 
AND a.state_province_id IS NULL AND match_method_state_province IS NULL 
AND 
(
c.state_province_name LIKE  '%'  || a.state_province_verbatim_alt || '%' OR 
a.state_province_verbatim_alt LIKE '%'  || c.state_province_name || '%'
) 
AND a.state_province_verbatim_alt IS NOT NULL AND a.state_province_verbatim_alt<>''
GROUP BY a.id, b.country_id, b.state_province_id, b.state_province_std
HAVING COUNT(DISTINCT b.state_province_id)=1
) sp
WHERE u.job=:'job' 
AND u.state_province_id IS NULL AND match_method_state_province IS NULL 
AND u.id=sp.id
;

--
-- Wildcard match on *exact* state name in county field
-- Done only if state_province_verbatim is null so as not to
-- confuse with true county-as-state
--

UPDATE user_data u
SET 
state_province_id=stateincounty.state_province_id,
state_province=stateincounty.state_province_std,
match_method_state_province='wildcard state-in-county-field'
FROM 
(
SELECT DISTINCT u.id, sp.state_province_id, sp.state_province_std
FROM user_data AS u JOIN state_province sp 
ON u.country_id=sp.country_id
WHERE u.job=:'job' 
AND (
unaccent(u.county_parish_verbatim) ILIKE  '%'  || sp.state_province_std || '%'
) 
) AS stateincounty 
WHERE u.job=:'job' 
AND u.state_province_id IS NULL
AND u.id=stateincounty.id
AND trim(coalesce(u.state_province_verbatim,''))='' -- Critical!
;
