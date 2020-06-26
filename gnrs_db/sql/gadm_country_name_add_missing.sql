-- -----------------------------------------------------------------
-- Add missing country names from GADM 
-- These have been added previously to geonames_country table
-- ---------------------------------------------------------------

-- Verbatim name
INSERT INTO country_name (
country_id,
country_name,
country_name_std,
name_type
)
SELECT 
a.country_id,
a.country,
unaccent(a.country),
'from GADM'
FROM country a LEFT JOIN country_name b 
ON a.country=b.country_name
WHERE b.country_name IS NULL
;

-- Plain ascii name
INSERT INTO country_name (
country_id,
country_name,
country_name_std,
name_type
)
SELECT 
a.country_id,
unaccent(a.country),
unaccent(a.country),
'from GADM'
FROM country a LEFT JOIN country_name b 
ON unaccent(a.country)=b.country_name
WHERE b.country_name IS NULL
;
