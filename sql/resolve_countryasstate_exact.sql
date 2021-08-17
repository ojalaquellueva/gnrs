-- ------------------------------------------------------------
-- Exact match countries treated as states in reference DBs
-- Populate both country and state_province at same time
-- Country is inferred by joining on state_province
-- ------------------------------------------------------------

-- standard name 
-- plain ascii, lower case
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='inferred from country-as-state',
state_province_id=c.state_province_id,
state_province=c.state_province_std,
match_method_state_province='exact standard name, country-as-state'
FROM country b JOIN state_province c
ON b.country_id=c.country_id
WHERE job=:'job'
AND c.is_countryasstate=1
AND a.country_id IS NULL AND match_status IS NULL
AND lower(unaccent(a.country_verbatim))=lower(c.state_province)
;

-- hasc, fips and iso codes
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='inferred from country-as-state',
state_province_id=c.state_province_id,
state_province=c.state_province_std,
match_method_state_province='hasc/fips/iso codes, country-as-state'
FROM country b JOIN state_province c
ON b.country_id=c.country_id
WHERE job=:'job'
AND c.is_countryasstate=1
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim IN (
c.state_province_code, 
c.state_province_code_full, 
c.hasc,
c. hasc_full,
c.state_province_code2,
c.state_province_code2_full
)
AND trim(a.country_verbatim)<>''
;

-- Exact alternate name
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='inferred from country-as-state',
state_province_id=c.state_province_id,
state_province=c.state_province_std,
match_method_state_province='exact alternate name, country-as-state'
FROM country b JOIN state_province c
ON b.country_id=c.country_id
JOIN state_province_name d
ON c.state_province_id=d.state_province_id
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND c.is_countryasstate=1
AND a.country_verbatim=d.state_province_name
;