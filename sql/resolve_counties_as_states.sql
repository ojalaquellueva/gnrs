-- ------------------------------------------------------------
--  Resolve county-as-state
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

-- standard name
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province,
match_method_state_province='county-as-state, exact standard name'
FROM country b JOIN state_province c
ON b.country_id=c.country_id
WHERE job=:'job'
AND a.match_method_country like 'state-as-country%'
AND a.country_id=b.country_id
AND LOWER(a.county_parish_verbatim)=LOWER(c.state_province_std)
;

-- standard name
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province,
match_method_state_province='county-as-state, exact standard name'
FROM country b JOIN state_province c
ON b.country_id=c.country_id
WHERE job=:'job'
AND a.match_method_country like 'state-as-country%'
AND a.country_id=b.country_id
AND LOWER(a.county_parish_verbatim)=LOWER(c.state_province)
;

-- ascii name
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province,
match_method_state_province='county-as-state, exact ascii name'
FROM country b JOIN state_province c
ON b.country_id=c.country_id
WHERE job=:'job'
AND a.match_method_country like 'state-as-country%'
AND a.country_id=b.country_id
AND LOWER(a.county_parish_verbatim)=LOWER(c.state_province_ascii)
;

-- ascii name
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province,
match_method_state_province='county-as-state, iso or other code'
FROM country b JOIN state_province c
ON b.country_id=c.country_id
WHERE job=:'job'
AND a.match_method_country like 'state-as-country%'
AND a.country_id=b.country_id
AND a.county_parish_verbatim IN (
c.state_province_code,
c.state_province_code_full,
c.hasc,
hasc_full,

;

