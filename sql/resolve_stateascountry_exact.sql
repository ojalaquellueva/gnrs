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
match_method_country='exact standard name, state-as-country',
state_province=NULL  -- Clear just in case
FROM country b JOIN country c
ON b.alt_country_id=c.country_id
WHERE job=:'job'
AND a.state_province_id IS NULL
AND a.country_id=c.country_id
AND LOWER(unaccent(a.state_province_verbatim))=LOWER(b.country)
;

--iso or fips codes
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='ISO/FIPS/HASC code, state-as-country',
state_province=NULL  -- Clear just in case
FROM country b JOIN country c
ON b.alt_country_id=c.country_id
WHERE job=:'job'
AND a.state_province_id IS NULL
AND a.country_id=c.country_id
AND a.state_province_verbatim IN (b.iso, b.iso_alpha3, b.fips)
;

-- alternate name
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='exact alternate name, state-as-country',
state_province=NULL  -- Clear just in case
FROM country b JOIN country c
ON b.alt_country_id=c.country_id
JOIN country_name d
ON b.country_id=d.country_id
WHERE job=:'job'
AND a.state_province_id IS NULL
AND a.country_id=c.country_id
AND (
LOWER(a.state_province_verbatim)=LOWER(d.country_name)
OR a.state_province_verbatim=d.country_name
)
;
