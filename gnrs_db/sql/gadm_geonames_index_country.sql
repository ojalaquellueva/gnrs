-- -----------------------------------------------------
-- Add geonameid to gadm country
-- -----------------------------------------------------

UPDATE gadm_country a
SET geonameid=b.country_id
FROM country b
WHERE a.gid_0=b.iso_alpha3
;

-- Fix screwed-up iso3 code for south sudan
UPDATE gadm_country a
SET gid_0='SSD'
WHERE name_0='South Sudan'
;


