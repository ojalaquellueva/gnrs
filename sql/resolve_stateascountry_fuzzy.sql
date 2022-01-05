-- ------------------------------------------------------------
--  Resolve state-as-country using fuzzy matching
-- ------------------------------------------------------------

-- --------------------------------------
-- Resolves political divisions which are treated as countries in 
-- the reference databases (GADM, Geonames) but are actually 
-- subnational units (states, provinces, territories, etc.)
-- If parent country is correct, populates the
-- country fields with name and id of state-as-country
-- Assumes country has already been resolve, therefore must
-- be performed after all other country checks have been
-- completed
-- --------------------------------------

--
-- Wildcard match - Alternate name
-- 
-- Does reciprocal searches 'string1' LIKE '%string2%' and 
-- 'string2' LIKE '%string1', where string1 is the verbatim (submitted)
-- state name and string2 is the reference state-as-country alternate name
-- Avoids homonym errors by updating only if query returns exactly 
-- one result for each submitted state-as_country
-- 

UPDATE user_data u
SET 
country_id=sac.country_id,
country=sac.country,
match_method_country='wildcard alternate name, state-as-country',
state_province=NULL,
state_province_id=NULL
FROM 
(
SELECT u.id, COUNT(DISTINCT c.country_id)
FROM user_data AS u JOIN country c ON u.country_id=c.country_id
JOIN country sac ON c.country_id=sac.alt_country_id
JOIN country_name sac_altname ON sac.country_id=sac_altname.country_id
WHERE u.job=:'job' 
AND (
sac_altname.country_name LIKE  '%'  || u.state_province_verbatim || '%' OR 
u.state_province_verbatim LIKE '%'  || sac_altname.country_name || '%'
) 
GROUP BY u.id
HAVING COUNT(DISTINCT sac.country_id)=1
) AS sac_uniq -- IDs of submitted state values returning exactly one SAC only
JOIN 
(
SELECT DISTINCT u.id, sac.country_id, sac.country
FROM user_data AS u JOIN country c ON u.country_id=c.country_id
JOIN country sac ON c.country_id=sac.alt_country_id
JOIN country_name sac_altname ON sac.country_id=sac_altname.country_id
WHERE u.job=:'job' 
AND (
sac_altname.country_name LIKE  '%'  || u.state_province_verbatim || '%' OR 
u.state_province_verbatim LIKE '%'  || sac_altname.country_name || '%'
) 
) AS sac -- Retrieves country id and name of SAC for submitted state/province
ON sac_uniq.id=sac.id -- Join ensures only unambiguous results used
WHERE u.job=:'job' 
AND u.state_province_id IS NULL
AND u.id=sac.id
AND TRIM(u.state_province_verbatim)<>''  -- Can match to anything so filter
AND u.state_province_verbatim NOT LIKE '%\_%'  -- Filter underscores (=wildcard)
AND u.state_province_verbatim<>'-'	-- Filter lone hyphen, matches any hyphenated name
;


--
-- Fuzzy match - standard name
--

UPDATE user_data u
SET 
country_id=sac.country_id,
country=sac.country,
match_method_country='fuzzy standard name, state-as-country',
match_score_country=max_sim,
state_province=NULL,
state_province_id=NULL
FROM 
(
SELECT
country_id,
country,
alt_country_id,
alt_country,
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
b.country_id,
b.country,
b.alt_country_id,
b.alt_country,
a.state_province_verbatim,
similarity(a.state_province_verbatim,b.country) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND state_province_id IS NULL
AND match_method_country NOT LIKE '%state-as-country%'
) a
JOIN
(
SELECT DISTINCT c.country_id as alt_country_id, c.country as alt_country,
sac.country_id, sac.country
FROM country c JOIN country sac ON c.country_id=sac.alt_country_id
) b
ON a.country_id=b.alt_country_id
) x
GROUP BY country_id, country, alt_country_id, alt_country, state_province_verbatim
HAVING MAX(similarity) >= :match_threshold
) sac
WHERE job=:'job'
AND u.state_province_id IS NULL
AND u.match_method_country NOT LIKE '%state-as-country%'
AND u.country_id=sac.alt_country_id
AND u.state_province_verbatim=sac.state_province_verbatim
;


--
-- Fuzzy match - alternate name
--

UPDATE user_data u
SET 
country_id=sac.country_id,
country=sac.country,
match_method_country='fuzzy alternate name, state-as-country',
match_score_country=max_sim,
state_province=NULL,
state_province_id=NULL
FROM 
(
SELECT
country_id,
country,
alt_country_id,
alt_country,
state_province_verbatim,
country_name,
MAX(similarity) AS max_sim
FROM
(
SELECT 
b.country_id,
b.country,
b.alt_country_id,
b.alt_country,
a.state_province_verbatim,
b.country_name,
similarity(a.state_province_verbatim,b.country_name) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND state_province_id IS NULL
AND match_method_country NOT LIKE '%state-as-country%'
) a
JOIN
(
SELECT DISTINCT c.country_id as alt_country_id, c.country as alt_country,
sac.country_id, sac.country, sac_altname.country_name
FROM country c JOIN country sac ON c.country_id=sac.alt_country_id
JOIN country_name sac_altname ON sac.country_id=sac_altname.country_id
) b
ON a.country_id=b.alt_country_id
) x
GROUP BY country_id, country, alt_country_id, alt_country, state_province_verbatim, country_name
HAVING MAX(similarity) >= :match_threshold
) sac
WHERE job=:'job'
AND u.state_province_id IS NULL
AND u.match_method_country NOT LIKE '%state-as-country%'
AND u.country_id=sac.alt_country_id
AND u.state_province_verbatim=sac.state_province_verbatim
;

