-- ------------------------------------------------------------------
-- Fixes misc errors in GNRS country tables
-- ------------------------------------------------------------------

-- 
-- country
-- 
UPDATE country
SET 
country='Czech Republic'
WHERE iso='CZ'  
;

UPDATE country_name a
SET 
country_name_std='Czech Republic'
FROM country b
WHERE a.country_id=b.country_id
AND b.iso='CZ'  
;
