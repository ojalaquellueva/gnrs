-- -----------------------------------------------------------------
-- Add missing state names from GADM 
-- ---------------------------------------------------------------

-- Verbatim name
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.state_province,
'from GADM'
FROM state_province a LEFT JOIN state_province_name b 
ON a.state_province=b.state_province_name
WHERE b.state_province_name IS NULL
;

-- Plain ascii name
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.state_province_ascii,
'from GADM'
FROM state_province a LEFT JOIN state_province_name b 
ON a.state_province_ascii=b.state_province_name
WHERE b.state_province_name IS NULL
;

-- Standard (GNRS) name
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.state_province_std,
'from GADM'
FROM state_province a LEFT JOIN state_province_name b 
ON a.state_province_std=b.state_province_name
WHERE b.state_province_name IS NULL
;
