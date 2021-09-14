-- ------------------------------------------------------------
--  Resolve county-as-state - Fuzzy & wildcard matches
-- ------------------------------------------------------------

-- --------------------------------------
-- Resolves political divisions which are treated as states (adm1) in 
-- the reference databases (GADM, Geonames) but are actually 
-- sub-state (adm2) units (county, municipio, etc.)
-- If parent country and state are correct, populates the
-- state field with name and id of the county-as-state
-- Assumes country and state have already been resolved, therefore must
-- be performed at end of all state checks 
-- --------------------------------------

--
-- Alternate names - simple wildcard match
-- Only if query returns exactly one result
-- 

UPDATE user_data u
SET 
state_province_id=cas_altname.state_province_id,
state_province=cas_altname.state_province_std,
match_method_state_province='wildcard alternate name, county-as-state',
county_parish=NULL,    -- Clear just in case
county_parish_id=NULL  -- Clear just in case
FROM 
(
SELECT u.id, COUNT(DISTINCT cas.state_province_id)
FROM user_data AS u JOIN state_province cas ON u.country_id=cas.country_id
JOIN state_province_name cas_altname 
ON cas.state_province_id=cas_altname.state_province_id
WHERE u.job=:'job' 
AND (
cas_altname.state_province_name LIKE  '%'  || u.county_parish_verbatim || '%' OR 
u.county_parish_verbatim LIKE '%'  || cas_altname.state_province_name || '%'
) 
GROUP BY u.id
HAVING COUNT(DISTINCT cas.state_province_id)=1
) AS cas_uniq -- IDs of user-submitted county values returning one CAS only
JOIN 
(
SELECT DISTINCT u.id, cas.state_province_id, cas.state_province_std
FROM user_data AS u JOIN state_province cas 
ON u.country_id=cas.country_id
JOIN state_province_name cas_altname 
ON cas.state_province_id=cas_altname.state_province_id
WHERE u.job=:'job' 
AND (
cas_altname.state_province_name LIKE  '%'  || u.county_parish_verbatim || '%' OR 
u.county_parish_verbatim LIKE '%'  || cas_altname.state_province_name || '%'
) 
) AS cas_altname -- Retrieves country id and name of SAC for submitted state/province
ON cas_uniq.id=cas_altname.id -- Join ensures only unambiguous results used
WHERE u.job=:'job' 
AND u.state_province_id IS NULL
AND u.id=cas_altname.id
AND u.match_method_country LIKE '%state-as-country%' -- Critical!
;

--
-- Standard name - fuzzy match
--

UPDATE user_data a
SET 
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy standard name, county-as-state',
match_score_state_province=fzy.similarity,
county_parish=NULL,    -- Clear just in case
county_parish_id=NULL  -- Clear just in case
FROM 
(
SELECT
q.county_parish_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
county_parish_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.county_parish_verbatim,
similarity(a.county_parish_verbatim, b.state_province) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND match_method_country LIKE '%state-as-country%'
AND state_province_id IS NULL
AND coalesce(county_parish_verbatim,'')<>''
) a 
JOIN state_province b 
ON a.country_id=b.country_id
) x
GROUP BY country_id, county_parish_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.county_parish_verbatim,
b.state_province_id,
b.state_province,
b.state_province_std,
similarity(a.county_parish_verbatim,b.state_province) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND match_method_country LIKE '%state-as-country%'
AND state_province_id IS NULL
AND coalesce(county_parish_verbatim,'')<>''
) a 
JOIN state_province b 
ON a.country_id=b.country_id
) p
ON q.county_parish_verbatim=p.county_parish_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.county_parish_verbatim=fzy.county_parish_verbatim
AND a.country_id=fzy.country_id
AND a.match_method_country LIKE '%state-as-country%'
AND a.state_province_id IS NULL
;

--
-- Standard ascii name - fuzzy match
--

UPDATE user_data a
SET 
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy standard name, county-as-state',
match_score_state_province=fzy.similarity,
county_parish=NULL,    -- Clear just in case
county_parish_id=NULL  -- Clear just in case
FROM 
(
SELECT
q.county_parish_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
county_parish_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.county_parish_verbatim,
similarity(a.county_parish_verbatim, b.state_province_ascii) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND match_method_country LIKE '%state-as-country%'
AND state_province_id IS NULL
AND coalesce(county_parish_verbatim,'')<>''
) a 
JOIN state_province b 
ON a.country_id=b.country_id
) x
GROUP BY country_id, county_parish_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.county_parish_verbatim,
b.state_province_id,
b.state_province,
b.state_province_std,
similarity(a.county_parish_verbatim,b.state_province_ascii) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND match_method_country LIKE '%state-as-country%'
AND state_province_id IS NULL
AND coalesce(county_parish_verbatim,'')<>''
) a 
JOIN state_province b 
ON a.country_id=b.country_id
) p
ON q.county_parish_verbatim=p.county_parish_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.county_parish_verbatim=fzy.county_parish_verbatim
AND a.country_id=fzy.country_id
AND a.match_method_country LIKE '%state-as-country%'
AND a.state_province_id IS NULL
;

--
-- GNRS standard ascii name - fuzzy match
--

UPDATE user_data a
SET 
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy standard name, county-as-state',
match_score_state_province=fzy.similarity,
county_parish=NULL,    -- Clear just in case
county_parish_id=NULL  -- Clear just in case
FROM 
(
SELECT
q.county_parish_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
county_parish_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.county_parish_verbatim,
similarity(a.county_parish_verbatim, b.state_province_std) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND match_method_country LIKE '%state-as-country%'
AND state_province_id IS NULL
AND coalesce(county_parish_verbatim,'')<>''
) a 
JOIN state_province b 
ON a.country_id=b.country_id
) x
GROUP BY country_id, county_parish_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.county_parish_verbatim,
b.state_province_id,
b.state_province,
b.state_province_std,
similarity(a.county_parish_verbatim,b.state_province_std) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE job=:'job'
AND match_method_country LIKE '%state-as-country%'
AND state_province_id IS NULL
AND state_province_id IS NULL
AND coalesce(county_parish_verbatim,'')<>''
) a 
JOIN state_province b 
ON a.country_id=b.country_id
) p
ON q.county_parish_verbatim=p.county_parish_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim >= :match_threshold
) AS fzy
WHERE job=:'job'
AND a.county_parish_verbatim=fzy.county_parish_verbatim
AND a.country_id=fzy.country_id
AND a.match_method_country LIKE '%state-as-country%'
AND a.state_province_id IS NULL
;
