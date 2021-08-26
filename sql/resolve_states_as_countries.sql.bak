-- ------------------------------------------------------------
--  Resolve state-as-country
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

-- standard name
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='state-as-country, exact standard name'
FROM country b
WHERE job=:'job'
AND a.country_id=b.parent_country_id
AND LOWER(a.state_province_verbatim)=LOWER(b.country)
;

--iso or fips codes
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='state-as-country, iso or fips code'
FROM country b
WHERE job=:'job'
AND a.country_id=b.parent_country_id
AND a.state_province_verbatim IN (b.iso, b.iso_alpha3, b.fips)
;

-- alternate name
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='state-as-country, alternate name'
FROM country b JOIN country_name c
ON b.country_id=c.country_id
WHERE job=:'job'
AND a.country_id=b.parent_country_id
AND LOWER(a.state_province_verbatim)=LOWER(c.country_name)
;
