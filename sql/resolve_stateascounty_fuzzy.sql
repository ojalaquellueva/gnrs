-- ------------------------------------------------------------
-- Fuzzy match states treated as counties in reference DBs
-- ------------------------------------------------------------

--
-- Alternate names - simple wildcard match
-- Only if query returns exactly one result
-- 

UPDATE user_data u
SET 
county_parish_id=alt.county_parish_id,
county_parish=alt.county_parish_std,
match_method_county_parish='wildcard alternate name, state-as-county'
FROM (
SELECT a.id, COUNT(DISTINCT b.county_parish_id)
FROM user_data a JOIN county_parish b
ON a.state_province_id=b.state_province_id
JOIN county_parish_name c
ON b.county_parish_id=c.county_parish_id
WHERE a.job=:'job' 
AND a.county_parish_id IS NULL AND a.match_status IS NULL
AND b.is_stateascounty=1
AND 
(
c.county_parish_name LIKE  '%'  || a.state_province_verbatim || '%' OR 
a.state_province_verbatim LIKE '%'  || c.county_parish_name || '%'
) 
AND a.state_province_verbatim IS NOT NULL AND a.state_province_verbatim<>''
GROUP BY a.id
HAVING COUNT(DISTINCT b.county_parish_id)=1
) AS uniq -- IDs of user-submitted names returning on standard name id only
JOIN 
(
SELECT a.id, b.state_province_id, b.county_parish_id, b.county_parish_std
FROM user_data a JOIN county_parish b
ON a.state_province_id=b.state_province_id
JOIN county_parish_name c
ON b.county_parish_id=c.county_parish_id
WHERE a.job=:'job' 
AND a.county_parish_id IS NULL AND a.match_status IS NULL
AND b.is_stateascounty=1
AND 
(
c.county_parish_name LIKE  '%'  || a.state_province_verbatim || '%' OR 
a.state_province_verbatim LIKE '%'  || c.county_parish_name || '%'
) 
AND a.state_province_verbatim IS NOT NULL AND a.state_province_verbatim<>''
) AS alt -- Retrieves standard id and name for submitted alt name
ON uniq.id=alt.id -- Join ensures only unambiguous results used
WHERE u.job=:'job' 
AND u.county_parish_id IS NULL AND match_status IS NULL
AND u.id=alt.id
;

--
-- standard name
--

UPDATE user_data a
SET 
county_parish_id=fzy.county_parish_id,
county_parish=fzy.county_parish_std,
match_method_county_parish='fuzzy standard name, state-as-county',
match_score_county_parish=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.county_parish_id,
p.county_parish_std,
p.similarity
FROM 
(
SELECT
state_province_id,
state_province_verbatim,
county_parish,
MAX(similarity) AS max_sim
FROM
(
SELECT 
b.state_province_id,
a.state_province_verbatim,
b.county_parish,
similarity(a.state_province_verbatim,b.county_parish) AS similarity
FROM (
SELECT DISTINCT state_province_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND county_parish_id IS NULL
AND state_province_verbatim<>''
) a,
(
SELECT a.state_province_id, b.county_parish 
FROM state_province a JOIN county_parish b 
ON a.state_province_id=b.state_province_id
WHERE b.is_stateascounty=1
) b
WHERE a.state_province_id=b.state_province_id
) x
GROUP BY state_province_id, state_province_verbatim, county_parish
) q 
JOIN 
(
SELECT 
b.state_province_id,
a.state_province_verbatim,
b.county_parish_id,
b.county_parish,
b.county_parish_std,
similarity(a.state_province_verbatim,b.county_parish) AS similarity
FROM (
SELECT DISTINCT state_province_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND county_parish_id IS NULL
AND state_province_verbatim<>''
) a,
(
SELECT a.state_province_id, b.county_parish_id, b.county_parish, b.county_parish_std
FROM state_province a JOIN county_parish b 
ON a.state_province_id=b.state_province_id
WHERE b.is_stateascounty=1
) b
WHERE a.state_province_id=b.state_province_id
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.state_province_id=p.state_province_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.state_province_verbatim=fzy.state_province_verbatim
AND a.county_parish_id IS NULL AND match_status IS NULL
;

--
-- standard ascii name
--

UPDATE user_data a
SET 
county_parish_id=fzy.county_parish_id,
county_parish=fzy.county_parish_std,
match_method_county_parish='fuzzy standard name, state-as-county',
match_score_county_parish=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.county_parish_id,
p.county_parish_std,
p.similarity
FROM 
(
SELECT
state_province_id,
state_province_verbatim,
county_parish,
MAX(similarity) AS max_sim
FROM
(
SELECT 
b.state_province_id,
a.state_province_verbatim,
b.county_parish,
similarity(a.state_province_verbatim,b.county_parish_ascii) AS similarity
FROM (
SELECT DISTINCT state_province_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND county_parish_id IS NULL
AND state_province_verbatim<>''
) a,
(
SELECT a.state_province_id, b.county_parish, b.county_parish_ascii
FROM state_province a JOIN county_parish b 
ON a.state_province_id=b.state_province_id
WHERE b.is_stateascounty=1
) b
WHERE a.state_province_id=b.state_province_id
) x
GROUP BY state_province_id, state_province_verbatim, county_parish
) q 
JOIN 
(
SELECT 
b.state_province_id,
a.state_province_verbatim,
b.county_parish_id,
b.county_parish,
b.county_parish_std,
similarity(a.state_province_verbatim,b.county_parish_ascii) AS similarity
FROM (
SELECT DISTINCT state_province_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND county_parish_id IS NULL
AND state_province_verbatim<>''
) a,
(
SELECT a.state_province_id, b.county_parish_id, b.county_parish, b.county_parish_ascii, b.county_parish_std
FROM state_province a JOIN county_parish b 
ON a.state_province_id=b.state_province_id
WHERE b.is_stateascounty=1
) b
WHERE a.state_province_id=b.state_province_id
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.state_province_id=p.state_province_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.state_province_verbatim=fzy.state_province_verbatim
AND a.county_parish_id IS NULL AND match_status IS NULL
;

--
--standard short ascii name
--

UPDATE user_data a
SET 
county_parish_id=fzy.county_parish_id,
county_parish=fzy.county_parish_std,
match_method_county_parish='fuzzy standard name, state-as-county',
match_score_county_parish=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.county_parish_id,
p.county_parish_std,
p.similarity
FROM 
(
SELECT
state_province_id,
state_province_verbatim,
county_parish,
MAX(similarity) AS max_sim
FROM
(
SELECT 
b.state_province_id,
a.state_province_verbatim,
b.county_parish,
similarity(a.state_province_verbatim,b.county_parish_std) AS similarity
FROM (
SELECT DISTINCT state_province_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND county_parish_id IS NULL
AND state_province_verbatim<>''
) a,
(
SELECT a.state_province_id, b.county_parish, b.county_parish_std
FROM state_province a JOIN county_parish b 
ON a.state_province_id=b.state_province_id
WHERE b.is_stateascounty=1
) b
WHERE a.state_province_id=b.state_province_id
) x
GROUP BY state_province_id, state_province_verbatim, county_parish
) q 
JOIN 
(
SELECT 
b.state_province_id,
a.state_province_verbatim,
b.county_parish_id,
b.county_parish,
b.county_parish_std,
similarity(a.state_province_verbatim,b.county_parish_std) AS similarity
FROM (
SELECT DISTINCT state_province_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND county_parish_id IS NULL
AND state_province_verbatim<>''
) a,
(
SELECT a.state_province_id, b.county_parish_id, b.county_parish, b.county_parish_std
FROM state_province a JOIN county_parish b 
ON a.state_province_id=b.state_province_id
WHERE b.is_stateascounty=1
) b
WHERE a.state_province_id=b.state_province_id
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.state_province_id=p.state_province_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.state_province_verbatim=fzy.state_province_verbatim
AND a.county_parish_id IS NULL AND match_status IS NULL
;

