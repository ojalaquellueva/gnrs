-- ------------------------------------------------------------
--  Resolve country
-- ------------------------------------------------------------

--
-- Standard names
-- 

-- standard name
UPDATE user_data a
SET 
state_province=b.state_province_std,
match_method_state_province='exact name'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province_verbatim=b.state_province
AND a.country=c.country
;

-- standard name ascii
UPDATE user_data a
SET 
state_province=b.state_province_std,
match_method_state_province='exact ascii name'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province IS NULL
AND a.state_province_verbatim=b.state_province_ascii
AND a.country=c.country
AND a.state_province_verbatim<>''
;

-- short name ascii
UPDATE user_data a
SET 
state_province=b.state_province_std,
match_method_state_province='exact ascii short name'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province IS NULL
AND a.state_province_verbatim=b.state_province_std
AND a.country=c.country
AND a.state_province_verbatim<>''
;

--
-- codes
-- 

-- full iso code
UPDATE user_data a
SET 
state_province=b.state_province_std,
match_method_state_province='full iso code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province IS NULL
AND a.state_province_verbatim=b.state_province_code_full
AND a.country=c.country
AND b.state_province<>''
AND b.state_province_code_full IS NOT NULL
;

-- full hasc code
UPDATE user_data a
SET 
state_province=b.state_province_std,
match_method_state_province='full hasc code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province IS NULL
AND a.state_province_verbatim=b.hasc_full
AND a.country=c.country
AND a.state_province_verbatim<>''
AND b.hasc_full IS NOT NULL
;

-- full alt code
UPDATE user_data a
SET 
state_province=b.state_province_std,
match_method_state_province='full alternate code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province IS NULL
AND a.state_province_verbatim=b.state_province_code2_full
AND a.country=c.country
AND a.state_province_verbatim<>''
AND b.state_province_code2_full IS NOT NULL
;

-- iso code
UPDATE user_data a
SET 
state_province=b.state_province_std,
match_method_state_province='iso code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province IS NULL
AND a.state_province_verbatim=b.state_province_code
AND a.country=c.country
AND a.state_province_verbatim<>''
AND b.state_province_code IS NOT NULL
;

-- hasc code
UPDATE user_data a
SET 
state_province=b.state_province_std,
match_method_state_province='hasc code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province IS NULL
AND a.state_province_verbatim=b.hasc
AND a.country=c.country
AND a.state_province_verbatim<>''
AND b.hasc IS NOT NULL
;

-- alt code
UPDATE user_data a
SET 
state_province=b.state_province_std,
match_method_state_province='alternate code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province IS NULL
AND a.state_province_verbatim=b.state_province_code2
AND a.country=c.country
AND a.state_province_verbatim<>''
AND b.state_province_code2 IS NOT NULL
;

--
-- Alternate names
-- 

UPDATE user_data a
SET 
state_province=b.state_province_std,
match_method_state_province='exact alternate name'
FROM state_province b JOIN state_province_name c
ON b.state_province_id=c.state_province_id
JOIN country d
ON b.country_id=d.country_id
WHERE a.state_province IS NULL
AND a.state_province_verbatim=c.state_province_name
AND c.name_type='original from geonames'
;