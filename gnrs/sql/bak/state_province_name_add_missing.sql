-- -----------------------------------------------------------------
-- ensures that all names and codes are present in name table 
-- ---------------------------------------------------------------

-- 
-- Add name type column names
-- 

-- Should be created with table, but doing here for now
ALTER TABLE state_province_name
ADD COLUMN name_type text
;
UPDATE state_province_name
SET name_type='original from geonames'
;

-- 
-- Add missing names
-- 

-- name
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.state_province,
'standard name'
FROM state_province a LEFT JOIN state_province_name b
ON a.state_province=b.state_province_name
AND a.state_province_id=b.state_province_id
WHERE b.state_province_id IS NULL
AND a.state_province IS NOT NULL
;

-- ascii name
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.state_province_ascii,
'ascii name'
FROM state_province a LEFT JOIN state_province_name b
ON a.state_province_ascii=b.state_province_name
AND a.state_province_id=b.state_province_id
WHERE b.state_province_id IS NULL
AND a.state_province_ascii IS NOT NULL
;

-- short ascii name
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.state_province_std,
'short ascii name'
FROM state_province a LEFT JOIN state_province_name b
ON a.state_province_std=b.state_province_name
AND a.state_province_id=b.state_province_id
WHERE b.state_province_id IS NULL
AND a.state_province_std IS NOT NULL
;

-- short iso code
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.state_province_code,
'short iso code'
FROM state_province a LEFT JOIN state_province_name b
ON a.state_province_code=b.state_province_name
AND a.state_province_id=b.state_province_id
WHERE b.state_province_id IS NULL
AND a.state_province_code IS NOT NULL
;

-- full iso code
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.state_province_code_full,
'full iso code'
FROM state_province a LEFT JOIN state_province_name b
ON a.state_province_code_full=b.state_province_name
AND a.state_province_id=b.state_province_id
WHERE b.state_province_id IS NULL
AND a.state_province_code_full IS NOT NULL
;

-- hasc code
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.hasc,
'hasc code'
FROM state_province a LEFT JOIN state_province_name b
ON a.hasc=b.state_province_name
AND a.state_province_id=b.state_province_id
WHERE b.state_province_id IS NULL
AND a.hasc IS NOT NULL
;

-- full hasc code
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.hasc_full,
'full hasc code'
FROM state_province a LEFT JOIN state_province_name b
ON a.hasc_full=b.state_province_name
AND a.state_province_id=b.state_province_id
WHERE b.state_province_id IS NULL
AND a.hasc_full IS NOT NULL
;

-- code2
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.state_province_code2,
'code2'
FROM state_province a LEFT JOIN state_province_name b
ON a.state_province_code2=b.state_province_name
AND a.state_province_id=b.state_province_id
WHERE b.state_province_id IS NULL
AND a.state_province_code2 IS NOT NULL
;

-- full code2
INSERT INTO state_province_name (
state_province_id,
state_province_name,
name_type
)
SELECT 
a.state_province_id,
a.state_province_code2_full,
'full code2'
FROM state_province a LEFT JOIN state_province_name b
ON a.state_province_code2_full=b.state_province_name
AND a.state_province_id=b.state_province_id
WHERE b.state_province_id IS NULL
AND a.state_province_code2_full IS NOT NULL
;

-- 
-- Add name type column names
-- 

-- Index the new column
CREATE INDEX state_province_name_name_type_idx ON state_province_name (name_type);
