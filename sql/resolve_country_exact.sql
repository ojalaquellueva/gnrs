-- ------------------------------------------------------------
-- Resolve country by exact matching
-- ------------------------------------------------------------

-- standard name 
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='exact standard name'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim=b.country
;

-- standard name case-insensitive
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='exact standard name'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND LOWER(a.country_verbatim)=LOWER(b.country)
;

-- plain ascii standard name
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='exact ascii name'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND unaccent(a.country_verbatim)=b.country
;

-- plain ascii standard name case-insensitive
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='exact ascii name'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND LOWER(unaccent(a.country_verbatim))=LOWER(b.country)
;

--
-- Codes
--
 
-- iso code
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='iso code'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim=b.iso
;

-- iso_alpha3 code
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='iso_alpha3 code'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim=b.iso_alpha3
;

-- fips code
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='fips code'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim=b.iso_alpha3
;

--
-- Alt names
--

-- Exact alternate name
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='exact alternate name'
FROM country b JOIN country_name c
ON b.country_id=c.country_id
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim=c.country_name
AND c.name_type='original from geonames'
;