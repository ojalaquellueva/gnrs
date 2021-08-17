-- ------------------------------------------------------------
-- Fuzzy match countries treated as states in reference DBs
-- Populate both country and state_province at same time
-- Country is inferred by joining on state_province
-- ------------------------------------------------------------

--
-- Alternate names - simple wildcard match
-- Only if query returns exactly one result
-- 

UPDATE user_data u
SET 
country_id=sp.country_id,
country=sp.country,
match_method_country='inferred from country-as-state',
state_province_id=sp.state_province_id,
state_province=sp.state_province_std,
match_method_state_province='wildcard alt name, country-as-state'
FROM (
SELECT a.id, b.country_id, b.country, b.state_province_id, b.state_province_std, COUNT(DISTINCT b.state_province_id)
FROM user_data a, state_province b, state_province_name c
WHERE a.job=:'job' 
AND b.state_province_id=c.state_province_id
AND a.country_id IS NULL AND a.match_status IS NULL
AND b.is_countryasstate=1
AND 
(
c.state_province_name LIKE  '%'  || a.country_verbatim || '%' OR 
a.country_verbatim LIKE '%'  || c.state_province_name || '%'
) 
AND a.country_verbatim IS NOT NULL AND a.country_verbatim<>''
GROUP BY a.id, b.country_id, b.country, b.state_province_id, b.state_province_std
HAVING COUNT(DISTINCT b.state_province_id)=1
) sp
WHERE u.job=:'job' 
AND u.country_id IS NULL AND match_status IS NULL
AND u.id=sp.id
;

--
-- standard name
--

UPDATE user_data a
SET 
country_id=fzy.country_id,
match_method_country='inferred from country-as-state',
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy standard name, country-as-state',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.country_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
country_verbatim,
state_province,
MAX(similarity) AS max_sim
FROM
(
SELECT 
b.country_id,
a.country_verbatim,
b.state_province,
similarity(a.country_verbatim,b.state_province) AS similarity
FROM (
SELECT DISTINCT country_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NULL
AND country_verbatim<>''
) a,
(
SELECT a.country_id, a.country, b.state_province FROM country a JOIN state_province b ON a.country_id=b.country_id
WHERE b.is_countryasstate=1
) b
) x
GROUP BY country_id, country_verbatim, state_province
) q 
JOIN 
(
SELECT 
b.country_id,
a.country_verbatim,
b.state_province_id,
b.state_province,
b.state_province_std,
similarity(a.country_verbatim,b.state_province) AS similarity
FROM (
SELECT DISTINCT country_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NULL 
AND country_verbatim<>''
) a,
(
SELECT a.country_id, a.country, b.state_province_id, b.state_province, b.state_province_std 
FROM country a JOIN state_province b ON a.country_id=b.country_id
WHERE b.is_countryasstate=1
) b
) p
ON q.country_verbatim=p.country_verbatim
AND q.max_sim=p.similarity
WHERE q.max_sim>:match_threshold
) AS fzy
WHERE job=:'job'
AND a.country_verbatim=fzy.country_verbatim
AND a.country_id IS NULL AND match_status IS NULL
;
-- Fill in spelled out country name
UPDATE user_data a
SET country=b.country
FROM country b
WHERE job=:'job'
AND a.country_id=b.country_id
AND a.country IS NULL
;


--
-- standard ascii name
--

UPDATE user_data a
SET 
country_id=fzy.country_id,
match_method_country='inferred from country-as-state',
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy standard name, country-as-state',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.country_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
country_verbatim,
state_province,
MAX(similarity) AS max_sim
FROM
(
SELECT 
b.country_id,
a.country_verbatim,
b.state_province,
similarity(a.country_verbatim,b.state_province_ascii) AS similarity
FROM (
SELECT DISTINCT country_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NULL
AND country_verbatim<>''
) a,
(
SELECT a.country_id, a.country, b.state_province, b.state_province_ascii FROM country a JOIN state_province b ON a.country_id=b.country_id
WHERE b.is_countryasstate=1
) b
) x
GROUP BY country_id, country_verbatim, state_province
) q 
JOIN 
(
SELECT 
b.country_id,
a.country_verbatim,
b.state_province_id,
b.state_province,
b.state_province_std,
similarity(a.country_verbatim,b.state_province_ascii) AS similarity
FROM (
SELECT DISTINCT country_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NULL 
AND country_verbatim<>''
) a,
(
SELECT a.country_id, a.country, b.state_province_id, b.state_province, b.state_province_ascii, b.state_province_std 
FROM country a JOIN state_province b ON a.country_id=b.country_id
WHERE b.is_countryasstate=1
) b
) p
ON q.country_verbatim=p.country_verbatim
AND q.max_sim=p.similarity
WHERE q.max_sim>:match_threshold
) AS fzy
WHERE job=:'job'
AND a.country_verbatim=fzy.country_verbatim
AND a.country_id IS NULL AND match_status IS NULL
;
-- Fill in spelled out country name
UPDATE user_data a
SET country=b.country
FROM country b
WHERE job=:'job'
AND a.country_id=b.country_id
AND a.country IS NULL
;


--
-- short ascii name
--

UPDATE user_data a
SET 
country_id=fzy.country_id,
match_method_country='inferred from country-as-state',
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy standard name, country-as-state',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.country_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
country_verbatim,
state_province,
MAX(similarity) AS max_sim
FROM
(
SELECT 
b.country_id,
a.country_verbatim,
b.state_province,
similarity(a.country_verbatim,b.state_province_std) AS similarity
FROM (
SELECT DISTINCT country_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NULL
AND country_verbatim<>''
) a,
(
SELECT a.country_id, a.country, b.state_province, b.state_province_std FROM country a JOIN state_province b ON a.country_id=b.country_id
WHERE b.is_countryasstate=1
) b
) x
GROUP BY country_id, country_verbatim, state_province
) q 
JOIN 
(
SELECT 
b.country_id,
a.country_verbatim,
b.state_province_id,
b.state_province,
b.state_province_std,
similarity(a.country_verbatim,b.state_province_std) AS similarity
FROM (
SELECT DISTINCT country_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NULL 
AND country_verbatim<>''
) a,
(
SELECT a.country_id, a.country, b.state_province_id, b.state_province, b.state_province_std
FROM country a JOIN state_province b ON a.country_id=b.country_id
WHERE b.is_countryasstate=1
) b
) p
ON q.country_verbatim=p.country_verbatim
AND q.max_sim=p.similarity
WHERE q.max_sim>:match_threshold
) AS fzy
WHERE job=:'job'
AND a.country_verbatim=fzy.country_verbatim
AND a.country_id IS NULL AND match_status IS NULL
;
-- Fill in spelled out country name
UPDATE user_data a
SET country=b.country
FROM country b
WHERE job=:'job'
AND a.country_id=b.country_id
AND a.country IS NULL
;
