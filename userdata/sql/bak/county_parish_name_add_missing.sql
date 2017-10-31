-- -----------------------------------------------------------------
-- ensures that all names and codes are present in name table 
-- ---------------------------------------------------------------

-- 
-- Add name type column names
-- 

-- Should be created with table, but doing here for now
ALTER TABLE county_parish_name
ADD COLUMN name_type text
;
UPDATE county_parish_name
SET name_type='original from geonames'
;

-- 
-- Add missing names
-- 

-- name
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.county_parish,
'standard name'
FROM county_parish a LEFT JOIN county_parish_name b
ON a.county_parish=b.county_parish_name
AND a.county_parish_id=b.county_parish_id
WHERE b.county_parish_id IS NULL
AND a.county_parish IS NOT NULL
;

-- ascii name
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.county_parish_ascii,
'ascii name'
FROM county_parish a LEFT JOIN county_parish_name b
ON a.county_parish_ascii=b.county_parish_name
AND a.county_parish_id=b.county_parish_id
WHERE b.county_parish_id IS NULL
AND a.county_parish_ascii IS NOT NULL
;

-- short ascii name
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.county_parish_std,
'short ascii name'
FROM county_parish a LEFT JOIN county_parish_name b
ON a.county_parish_std=b.county_parish_name
AND a.county_parish_id=b.county_parish_id
WHERE b.county_parish_id IS NULL
AND a.county_parish_std IS NOT NULL
;

-- short iso code
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.county_parish_code,
'short iso code'
FROM county_parish a LEFT JOIN county_parish_name b
ON a.county_parish_code=b.county_parish_name
AND a.county_parish_id=b.county_parish_id
WHERE b.county_parish_id IS NULL
AND a.county_parish_code IS NOT NULL
;

-- full iso code
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.county_parish_code_full,
'full iso code'
FROM county_parish a LEFT JOIN county_parish_name b
ON a.county_parish_code_full=b.county_parish_name
AND a.county_parish_id=b.county_parish_id
WHERE b.county_parish_id IS NULL
AND a.county_parish_code_full IS NOT NULL
;

-- hasc code
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.hasc_2,
'hasc code'
FROM county_parish a LEFT JOIN county_parish_name b
ON a.hasc_2=b.county_parish_name
AND a.county_parish_id=b.county_parish_id
WHERE b.county_parish_id IS NULL
AND a.hasc_2 IS NOT NULL
;

-- full hasc code
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.hasc_2_full,
'full hasc code'
FROM county_parish a LEFT JOIN county_parish_name b
ON a.hasc_2_full=b.county_parish_name
AND a.county_parish_id=b.county_parish_id
WHERE b.county_parish_id IS NULL
AND a.hasc_2_full IS NOT NULL
;

-- code2
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.county_parish_code2,
'code2'
FROM county_parish a LEFT JOIN county_parish_name b
ON a.county_parish_code2=b.county_parish_name
AND a.county_parish_id=b.county_parish_id
WHERE b.county_parish_id IS NULL
AND a.county_parish_code2 IS NOT NULL
;

-- full code2
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.county_parish_code2_full,
'full code2'
FROM county_parish a LEFT JOIN county_parish_name b
ON a.county_parish_code2_full=b.county_parish_name
AND a.county_parish_id=b.county_parish_id
WHERE b.county_parish_id IS NULL
AND a.county_parish_code2_full IS NOT NULL
;

-- 
-- Add name type column names
-- 

-- Index the new column
CREATE INDEX county_parish_name_name_type_idx ON county_parish_name (name_type);
