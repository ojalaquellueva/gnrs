-- ------------------------------------------------------------
--  Resolve coounty_parish
-- ------------------------------------------------------------

--
-- Standard names
-- 

-- standard name
UPDATE user_data a
SET 
county_parish=b.county_parish_std,
match_method_county_parish='exact name'
FROM county_parish b JOIN state_province c
ON b.state_province_id=c.state_province_id
JOIN country d
ON c.country_id=d.country_id
WHERE a.county_parish_verbatim=b.county_parish 
AND a.county_parish IS NULL
AND a.country=d.country
AND a.state_province=c.state_province_std
AND a.county_parish_verbatim<>''
;

-- standard name ascii
UPDATE user_data a
SET 
county_parish=b.county_parish_std,
match_method_county_parish='exact ascii name'
FROM county_parish b JOIN state_province c
ON b.state_province_id=c.state_province_id
JOIN country d
ON c.country_id=d.country_id
WHERE a.county_parish_verbatim=b.county_parish_ascii 
AND a.county_parish IS NULL
AND a.country=d.country
AND a.state_province=c.state_province_std
AND a.county_parish_verbatim<>''
;

-- short name ascii
UPDATE user_data a
SET 
county_parish=b.county_parish_std,
match_method_county_parish='exact ascii short name'
FROM county_parish b JOIN state_province c
ON b.state_province_id=c.state_province_id
JOIN country d
ON c.country_id=d.country_id
WHERE a.county_parish_verbatim=b.county_parish_std 
AND a.county_parish IS NULL
AND a.country=d.country
AND a.state_province=c.state_province_std
AND a.county_parish_verbatim<>''
;

--
-- codes
-- 

-- full iso code
UPDATE user_data a
SET 
county_parish=b.county_parish_std,
match_method_county_parish='full iso code'
FROM county_parish b JOIN state_province c
ON b.state_province_id=c.state_province_id
JOIN country d
ON c.country_id=d.country_id
WHERE a.county_parish_verbatim=b.county_parish_code_full 
AND a.county_parish IS NULL
AND a.country=d.country
AND a.state_province=c.state_province_std
AND a.county_parish_verbatim<>''
;

-- full hasc code
UPDATE user_data a
SET 
county_parish=b.county_parish_std,
match_method_county_parish='full hasc code'
FROM county_parish b JOIN state_province c
ON b.state_province_id=c.state_province_id
JOIN country d
ON c.country_id=d.country_id
WHERE a.county_parish_verbatim=b.hasc_2_full 
AND a.county_parish IS NULL
AND a.country=d.country
AND a.state_province=c.state_province_std
AND a.county_parish_verbatim<>''
;

-- full alt code
UPDATE user_data a
SET 
county_parish=b.county_parish_std,
match_method_county_parish='full alternate code'
FROM county_parish b JOIN state_province c
ON b.state_province_id=c.state_province_id
JOIN country d
ON c.country_id=d.country_id
WHERE a.county_parish_verbatim=b.county_parish_code2_full 
AND a.county_parish IS NULL
AND a.country=d.country
AND a.state_province=c.state_province_std
AND a.county_parish_verbatim<>''
;

-- iso code
UPDATE user_data a
SET 
county_parish=b.county_parish_std,
match_method_county_parish='iso code'
FROM county_parish b JOIN state_province c
ON b.state_province_id=c.state_province_id
JOIN country d
ON c.country_id=d.country_id
WHERE a.county_parish_verbatim=b.county_parish_code 
AND a.county_parish IS NULL
AND a.country=d.country
AND a.state_province=c.state_province_std
AND a.county_parish_verbatim<>''
;

-- hasc code
UPDATE user_data a
SET 
county_parish=b.county_parish_std,
match_method_county_parish='hasc code'
FROM county_parish b JOIN state_province c
ON b.state_province_id=c.state_province_id
JOIN country d
ON c.country_id=d.country_id
WHERE a.county_parish_verbatim=b.hasc_2 
AND a.county_parish IS NULL
AND a.country=d.country
AND a.state_province=c.state_province_std
AND a.county_parish_verbatim<>''
;

-- alt code
UPDATE user_data a
SET 
county_parish=b.county_parish_std,
match_method_county_parish='alternate code'
FROM county_parish b JOIN state_province c
ON b.state_province_id=c.state_province_id
JOIN country d
ON c.country_id=d.country_id
WHERE a.county_parish_verbatim=b.county_parish_code2 
AND a.county_parish IS NULL
AND a.country=d.country
AND a.state_province=c.state_province_std
AND a.county_parish_verbatim<>''
;

--
-- Alternate names
-- 

UPDATE user_data a
SET 
county_parish=b.county_parish_std,
match_method_county_parish='exact alternate name'
FROM county_parish b JOIN county_parish_name c
ON b.county_parish_id=c.county_parish_id
JOIN state_province d
ON b.state_province_id=d.state_province_id
JOIN country e
ON d.country_id=e.country_id
WHERE a.county_parish_verbatim=c.county_parish_name
AND a.county_parish IS NULL
AND c.name_type='original from geonames'
AND a.country=e.country
AND a.state_province=d.state_province_std
AND a.county_parish_verbatim<>''
;