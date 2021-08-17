-- ------------------------------------------------------------
-- Exact match states treated as counties in reference DBs
-- ------------------------------------------------------------

-- standard name 
-- plain ascii, lower case
UPDATE user_data a
SET 
county_parish_id=c.county_parish_id,
county_parish=c.county_parish_std,
match_method_county_parish='exact standard name, state-as-county'
FROM state_province b JOIN county_parish c
ON b.state_province_id=c.state_province_id
WHERE job=:'job'
AND c.is_stateascounty=1
AND a.county_parish_id IS NULL AND match_status IS NULL
AND lower(unaccent(a.state_province_verbatim)) IN (
lower(c.county_parish),
lower(c.county_parish_ascii),
lower(c.county_parish_std)
)
;

-- hasc, fips and iso codes
UPDATE user_data a
SET 
county_parish_id=c.county_parish_id,
county_parish=c.county_parish_std,
match_method_county_parish='hasc/fips/iso codes, state-as-county'
FROM state_province b JOIN county_parish c
ON b.state_province_id=c.state_province_id
WHERE job=:'job'
AND c.is_stateascounty=1
AND a.county_parish_id IS NULL AND match_status IS NULL
AND a.state_province_verbatim IN (
c.county_parish_code, 
c.county_parish_code_full, 
c.hasc_2,
c.hasc_2_full,
c.county_parish_code2,
c.county_parish_code2_full
)
AND trim(a.state_province_verbatim)<>''
;

-- Exact alternate name
UPDATE user_data a
SET 
county_parish_id=c.county_parish_id,
county_parish=c.county_parish_std,
match_method_county_parish='exact alternate name, state-as-county'
FROM state_province b JOIN county_parish c
ON b.state_province_id=c.state_province_id
JOIN county_parish_name d
ON c.county_parish_id=d.county_parish_id
WHERE job=:'job'
AND c.is_stateascounty=1
AND a.county_parish_id IS NULL AND match_status IS NULL
AND a.state_province_verbatim=d.county_parish_name
;