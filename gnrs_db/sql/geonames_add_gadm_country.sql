-- -----------------------------------------------------
-- Add missing gadm countries to geonames country table
-- -----------------------------------------------------

-- -- Keeps test runs from screwing up
-- -- Comment out for production or if this is first run
-- -- Will throw error if column is_geoname has not yet been added!
-- DELETE FROM country
-- WHERE is_geoname=0
-- ;

-- Add columns to flag gadm and geonames names
ALTER TABLE country
ADD COLUMN IF NOT EXISTS is_geoname INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS is_gadm INT DEFAULT 0
;

-- Flag geonames names
UPDATE country
SET is_geoname=1
;

-- Flag existing gadm names
UPDATE country a
SET is_gadm=1
FROM gadm_country b
WHERE a.country_id=b.geonameid
;

--
-- Turn geoname ID field into serial
--

-- Create the sequence and link to country
DROP SEQUENCE IF EXISTS country_country_id_seq CASCADE;
CREATE SEQUENCE country_country_id_seq;
ALTER TABLE country ALTER COLUMN country_id SET DEFAULT nextval('country_country_id_seq');
ALTER TABLE country ALTER COLUMN country_id SET NOT NULL;
ALTER SEQUENCE country_country_id_seq OWNED BY country.country_id;

-- Set tne next value in sequence
-- id will continue to increment by 1
-- Note that max values comes fromm geonames, not country
SELECT setval('country_country_id_seq', COALESCE((
SELECT MAX(geonameid)+1 FROM geoname),
1),false);

--
-- Add missing gadm names
-- Need to figure out how to populate rest of info!!
-- 
INSERT INTO country (
country,
iso_alpha3,
is_gadm
)
SELECT
name_0,
gid_0,
1
FROM gadm_country a LEFT JOIN country b
ON a.geonameid=b.country_id
WHERE b.country_id IS NULL
;

--
-- Flag original geonames names in gadm_country
--

ALTER TABLE gadm_country
ADD COLUMN IF NOT EXISTS is_original_geoname INT DEFAULT 0
; 
UPDATE gadm_country
SET is_original_geoname=1
WHERE geonameid IS NOT NULL
;

--
-- Now populate gadm_country.geonameid for newly-added countries 
--

UPDATE gadm_country a
SET geonameid=b.country_id
FROM country b
WHERE a.gid_0=b.iso_alpha3
AND a.geonameid IS NULL
;

--
-- Remove constraint and sequence 
--
ALTER TABLE country ALTER COLUMN country_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS country_country_id_seq;
