-- ------------------------------------------------------------
--  Resolve country
-- ------------------------------------------------------------


-- standard name
UPDATE user_data a
SET 
country=b.country,
match_method_country='exact standard name'
FROM country b
WHERE a.country_verbatim=b.country
;

-- iso code
UPDATE user_data a
SET 
country=b.country,
match_method_country='iso code'
FROM country b
WHERE a.country IS NULL
AND a.country_verbatim=b.iso
;

-- iso_alpha3 code
UPDATE user_data a
SET 
country=b.country,
match_method_country='iso_alpha3 code'
FROM country b
WHERE a.country IS NULL
AND a.country_verbatim=b.iso_alpha3
;

-- fips code
UPDATE user_data a
SET 
country=b.country,
match_method_country='fips code'
FROM country b
WHERE a.country IS NULL
AND a.country_verbatim=b.iso_alpha3
;

-- Exact alternate name
UPDATE user_data a
SET 
country=b.country,
match_method_country='exact alternate name'
FROM country b JOIN country_name c
ON b.country_id=c.country_id
WHERE a.country IS NULL
AND a.country_verbatim=c.country_name
AND c.name_type='original from geonames'
;