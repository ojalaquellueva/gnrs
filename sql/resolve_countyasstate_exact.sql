-- ------------------------------------------------------------
--  Resolve county-as-state - exact match
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
UPDATE user_data u
SET 
state_province_id=cas.state_province_id,
state_province=cas.state_province_std,
match_method_state_province='exact standard name, county-as-state',
county_parish=NULL,    -- Clear just in case
county_parish_id=NULL  -- Clear just in case
FROM country c JOIN state_province cas
ON c.country_id=cas.country_id
WHERE job=:'job'
AND u.state_province_id IS NULL
AND c.alt_country_id IS NOT NULL
AND u.match_method_country like '%state-as-country%'
AND u.country_id=c.country_id
AND (
LOWER(unaccent(u.county_parish_verbatim))=LOWER(cas.state_province_ascii)
OR
LOWER(unaccent(u.county_parish_verbatim))=LOWER(cas.state_province_std)
)
;

--iso or fips codes
UPDATE user_data u
SET 
state_province_id=cas.state_province_id,
state_province=cas.state_province_std,
match_method_state_province='ISO/FIPS/HASC code, county-as-state',
county_parish=NULL,    -- Clear just in case
county_parish_id=NULL  -- Clear just in case
FROM country sac JOIN state_province cas
ON sac.country_id=cas.country_id
WHERE job=:'job'
AND u.state_province_id IS NULL
AND sac.alt_country_id IS NOT NULL
AND u.match_method_country like '%state-as-country%'
AND u.country_id=sac.country_id
AND u.county_parish_verbatim IN (
cas.state_province_code, 
cas.state_province_code_full, 
cas.hasc,
cas.hasc_full,
cas.state_province_code2,
cas.state_province_code2_full,
cas.fips_code_full
)
;

-- alternate name
UPDATE user_data u
SET 
state_province_id=cas.state_province_id,
state_province=cas.state_province_std,
match_method_state_province='exact standard name, county-as-state',
county_parish=NULL,    -- Clear just in case
county_parish_id=NULL  -- Clear just in case
FROM country sac JOIN state_province cas
ON sac.country_id=cas.country_id
JOIN state_province_name cas_altname
ON cas.state_province_id=cas_altname.state_province_id
WHERE job=:'job'
AND u.state_province_id IS NULL
AND sac.alt_country_id IS NOT NULL
AND u.match_method_country like '%state-as-country%'
AND u.country_id=sac.country_id
AND (
LOWER(unaccent(u.county_parish_verbatim))=LOWER(cas_altname.state_province_name)
OR -- In case non-Latin languages corrupted by LOWER():
u.county_parish_verbatim=cas_altname.state_province_name
)
;


