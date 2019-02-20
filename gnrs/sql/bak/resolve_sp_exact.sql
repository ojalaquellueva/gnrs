-- ------------------------------------------------------------
--  Resolve country
-- ------------------------------------------------------------

-- Index only as needed
-- Index on country_id should already exist

DROP INDEX IF EXISTS user_data_state_province_verbatim_idx;
CREATE INDEX user_data_state_province_verbatim_idx ON user_data (state_province_verbatim);
DROP INDEX IF EXISTS user_data_state_province_id_isnull_idx;
CREATE INDEX user_data_state_province_id_isnull_idx ON user_data (state_province_id) WHERE state_province_id IS NULL;

-- Not needed, speeds thing up a bit to drop
DROP INDEX IF EXISTS user_data_country_verbatim_idx;

--
-- Standard names
-- 

-- standard name
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province_std,
match_method_state_province='exact name'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province_id IS NULL AND match_status IS NULL
AND a.state_province_verbatim=b.state_province
AND a.country_id=c.country_id
;

-- standard name ascii
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province_std,
match_method_state_province='exact ascii name'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province_id IS NULL AND match_status IS NULL
AND unaccent(a.state_province_verbatim)=b.state_province_ascii
AND a.country_id=c.country_id
AND a.state_province_verbatim<>''
;

-- short name ascii
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province_std,
match_method_state_province='exact ascii short name'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province_id IS NULL AND match_status IS NULL
AND unaccent(a.state_province_verbatim)=b.state_province_std
AND a.country_id=c.country_id
AND a.state_province_verbatim<>''
;

--
-- codes
-- 

-- full iso code
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province_std,
match_method_state_province='full iso code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province_id IS NULL AND match_status IS NULL
AND a.state_province_verbatim=b.state_province_code_full
AND a.country_id=c.country_id
AND b.state_province<>''
AND b.state_province_code_full IS NOT NULL
;

-- full hasc code
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province_std,
match_method_state_province='full hasc code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province_id IS NULL AND match_status IS NULL
AND a.state_province_verbatim=b.hasc_full
AND a.country_id=c.country_id
AND a.state_province_verbatim<>''
AND b.hasc_full IS NOT NULL
;

-- full alt code
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province_std,
match_method_state_province='full alternate code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province_id IS NULL AND match_status IS NULL
AND a.state_province_verbatim=b.state_province_code2_full
AND a.country_id=c.country_id
AND a.state_province_verbatim<>''
AND b.state_province_code2_full IS NOT NULL
;

-- iso code
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province_std,
match_method_state_province='iso code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province_id IS NULL AND match_status IS NULL
AND a.state_province_verbatim=b.state_province_code
AND a.country_id=c.country_id
AND a.state_province_verbatim<>''
AND b.state_province_code IS NOT NULL
;

-- hasc code
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province_std,
match_method_state_province='hasc code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province_id IS NULL AND match_status IS NULL
AND a.state_province_verbatim=b.hasc
AND a.country_id=c.country_id
AND a.state_province_verbatim<>''
AND b.hasc IS NOT NULL
;

-- alt code
UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province_std,
match_method_state_province='alternate code'
FROM state_province b JOIN country c
ON b.country_id=c.country_id
WHERE a.state_province_id IS NULL AND match_status IS NULL
AND a.state_province_verbatim=b.state_province_code2
AND a.country_id=c.country_id
AND a.state_province_verbatim<>''
AND b.state_province_code2 IS NOT NULL
;

--
-- Alternate names
-- 

UPDATE user_data a
SET 
state_province_id=b.state_province_id,
state_province=b.state_province_std,
match_method_state_province='exact alternate name'
FROM state_province b JOIN state_province_name c
ON b.state_province_id=c.state_province_id
JOIN country d
ON b.country_id=d.country_id
WHERE a.state_province_id IS NULL AND match_status IS NULL
AND a.state_province_verbatim=c.state_province_name
AND a.country_id=d.country_id
AND c.name_type='original from geonames'
;