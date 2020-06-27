-- -----------------------------------------------------------------
-- ensures that all names and codes are present in name table 
-- ---------------------------------------------------------------

-- Type of name
-- Should be created with table, but doing here for now
ALTER TABLE country_name
ADD COLUMN name_type text
;
UPDATE country_name
SET name_type='original from geonames'
;

-- 
-- Add missing names
-- 

-- name
INSERT INTO country_name (
country_id,
country_name,
country_name_std,
name_type
)
SELECT 
a.country_id,
a.country,
a.country,
'standard name en'
FROM country a LEFT JOIN country_name b
ON a.country=b.country_name
AND a.country_id=b.country_id
WHERE b.country_id IS NULL
;

-- iso code
INSERT INTO country_name (
country_id,
country_name,
country_name_std,
name_type
)
SELECT 
a.country_id,
a.iso,
a.country,
'iso code'
FROM country a LEFT JOIN country_name b
ON a.iso=b.country_name
AND a.country_id=b.country_id
WHERE b.country_id IS NULL
AND a.iso IS NOT NULL
;

-- iso-alpha3 code
INSERT INTO country_name (
country_id,
country_name,
country_name_std,
name_type
)
SELECT 
a.country_id,
a.iso_alpha3,
a.country,
'iso alpha3 code'
FROM country a LEFT JOIN country_name b
ON a.iso_alpha3=b.country_name
AND a.country_id=b.country_id
WHERE b.country_id IS NULL
AND a.iso_alpha3 IS NOT NULL 
;

-- fips code
INSERT INTO country_name (
country_id,
country_name,
country_name_std,
name_type
)
SELECT 
a.country_id,
a.fips,
a.country,
'fips code'
FROM country a LEFT JOIN country_name b
ON a.fips=b.country_name
AND a.country_id=b.country_id
WHERE b.country_id IS NULL
AND a.fips IS NOT NULL 
;

-- Index the new column
CREATE INDEX country_name_name_type_idx ON country_name (name_type);
