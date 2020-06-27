-- -----------------------------------------------------
-- Add missing gadm admin 1 political divisions to 
-- geonames country table
-- -----------------------------------------------------

-- -- Keeps test runs from screwing up
-- -- Comment out for production or if this is first run
-- -- Will throw error if column is_geoname has not yet been added!
-- DELETE FROM state_province
-- WHERE is_geoname=0
-- ;

-- Add columns to flag gadm and geonames names
ALTER TABLE state_province
ADD COLUMN IF NOT EXISTS is_geoname INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS is_gadm INT DEFAULT 0
;

-- Flag geonames names
UPDATE state_province
SET is_geoname=1
;

-- Flag existing gadm poldivs
UPDATE state_province a
SET is_gadm=1
FROM gadm_admin_1 b
WHERE a.state_province_id=b.geonameid
;

--
-- Turn geoname ID field into serial
--

-- Create the sequence and link to state_province
ALTER TABLE IF EXISTS state_province ALTER COLUMN state_province_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS state_province_state_province_id_seq CASCADE;
CREATE SEQUENCE state_province_state_province_id_seq;
ALTER TABLE state_province ALTER COLUMN state_province_id SET DEFAULT nextval('state_province_state_province_id_seq');
ALTER TABLE state_province ALTER COLUMN state_province_id SET NOT NULL;
ALTER SEQUENCE state_province_state_province_id_seq OWNED BY state_province.state_province_id;

-- Set tne next value in sequence
-- id will continue to increment by 1
-- Note that max value is the maximum value in both geoname and
-- country. This ensure new values will be higher
-- than any currently in use
SELECT setval('state_province_state_province_id_seq', 
COALESCE( 
(SELECT GREATEST(
	(SELECT MAX(geonameid)+1 FROM geoname),
	(SELECT MAX(country_id)+1 FROM country),
	(SELECT MAX(state_province_id)+1 FROM state_province)
)),
1),
false
);

--
-- Add missing gadm names
-- Need to figure out how to populate rest of info!!
-- 

INSERT INTO state_province (
country_iso,
country_iso_alpha3,
state_province,
state_province_ascii,
state_province_std,
hasc_full,
is_gadm
)
SELECT
a.country_iso,
a.gid_0,
name_1,
name_1_ascii,
name_1_ascii,
hasc_1,
1
FROM gadm_admin_1 a LEFT JOIN state_province b
ON a.geonameid=b.state_province_id
WHERE b.state_province_id IS NULL
;

-- Now update country using geonames country table
UPDATE state_province a
SET country_id=b.country_id,
country=b.country,
country_iso=b.iso
FROM country b
WHERE a.country_iso_alpha3=b.iso_alpha3
AND a.is_geoname=0
;

--
-- Flag original geonames names in gadm_admin_1
--

ALTER TABLE gadm_admin_1
ADD COLUMN IF NOT EXISTS is_original_geoname INT DEFAULT 0
; 
UPDATE gadm_admin_1
SET is_original_geoname=1
WHERE geonameid IS NOT NULL
;

--
-- Now populate gadm_admin_1.geonameid for newly-added states
--

UPDATE gadm_admin_1 a
SET geonameid=b.country_id
FROM state_province b
WHERE a.gid_0=b.country_iso_alpha3
AND a.geonameid IS NULL
;

--
-- Remove constraint and sequence 
--
ALTER TABLE IF EXISTS state_province ALTER COLUMN state_province_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS state_province_state_province_id_seq;
