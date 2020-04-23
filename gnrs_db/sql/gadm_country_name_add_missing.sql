-- -----------------------------------------------------------------
-- Add missing country names from GADM 
-- ---------------------------------------------------------------

INSERT INTO country_name (
country_id,
country_name,
country_name_std,
name_type
)
SELECT 
gadm.country_id,
gadm.country_name,
gadm.country,
'from GADM'
FROM 
(
SELECT b.country_id, a.country as country_name, b.country 
FROM gadm_country a JOIN country b
ON a.iso_3=b.iso_alpha3
WHERE a.country<>b.country
) gadm 
LEFT JOIN country_name gnrs 
ON gadm.country_name=gnrs.country_name
WHERE gnrs.country_name IS NULL
;
