-- -----------------------------------------------------------------
-- Add missing county names from GADM 
-- ---------------------------------------------------------------

-- Verbatim name
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.county_parish,
'from GADM'
FROM county_parish a LEFT JOIN county_parish_name b 
ON a.county_parish=b.county_parish_name
WHERE b.county_parish_name IS NULL
;

-- Plain ascii name
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.county_parish_ascii,
'from GADM'
FROM county_parish a LEFT JOIN county_parish_name b 
ON a.county_parish_ascii=b.county_parish_name
WHERE b.county_parish_name IS NULL
;

-- Standard (GNRS) name
INSERT INTO county_parish_name (
county_parish_id,
county_parish_name,
name_type
)
SELECT 
a.county_parish_id,
a.county_parish_std,
'from GADM'
FROM county_parish a LEFT JOIN county_parish_name b 
ON a.county_parish_std=b.county_parish_name
WHERE b.county_parish_name IS NULL
;
