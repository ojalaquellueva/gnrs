-- -----------------------------------------------------
-- Add missing gadm admin 2 political divisions to 
-- geonames country table
-- -----------------------------------------------------

-- -- Keeps test runs from screwing up
-- -- Comment out for production or if this is first run
-- -- Will throw error if column is_geoname has not yet been added!
-- DELETE FROM county_parish
-- WHERE is_geoname=0
-- ;

-- Add columns to flag gadm and geonames names
ALTER TABLE county_parish
ADD COLUMN IF NOT EXISTS hasc_1_full text DEFAULT NULL,
ADD COLUMN IF NOT EXISTS hasc_1_full_alt text DEFAULT NULL,
ADD COLUMN IF NOT EXISTS is_geoname INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS is_gadm INT DEFAULT 0
;

-- Flag geonames names
UPDATE county_parish
SET is_geoname=1
;

-- Flag existing gadm poldivs
UPDATE county_parish a
SET is_gadm=1
FROM gadm_admin_2 b
WHERE a.county_parish_id=b.geonameid
;

--
-- Turn geoname ID field into serial
--

-- Create the sequence and link to county_parish
DROP SEQUENCE IF EXISTS county_parish_county_parish_id_seq CASCADE;
CREATE SEQUENCE county_parish_county_parish_id_seq;
ALTER TABLE county_parish ALTER COLUMN county_parish_id SET DEFAULT nextval('county_parish_county_parish_id_seq');
ALTER TABLE county_parish ALTER COLUMN county_parish_id SET NOT NULL;
ALTER SEQUENCE county_parish_county_parish_id_seq OWNED BY county_parish.county_parish_id;

-- Set tne next value in sequence
-- id will continue to increment by 1
-- Note that max value is the maximum value in both geoname and
-- state_province. This ensure new values will be higher
-- than any currently in use
SELECT setval('county_parish_county_parish_id_seq', 
COALESCE( 
(SELECT GREATEST(
	(SELECT MAX(geonameid)+1 FROM geoname),
	(SELECT MAX(country_id)+1 FROM country),
	(SELECT MAX(state_province_id)+1 FROM state_province),
	(SELECT MAX(county_parish_id)+1 FROM county_parish)
)),
1),
false
);

--
-- Add missing gadm names
-- Need to figure out how to populate rest of info!!
-- 

INSERT INTO county_parish (
country_iso,
country_iso_alpha3,
state_province,
state_province_ascii,
hasc_1_full,
county_parish,
county_parish_ascii,
county_parish_std,
hasc_2_full,
is_gadm
)
SELECT
a.country_iso,
a.gid_0,
a.name_1,
a.name_1_ascii,
a.hasc_1,
a.name_2,
a.name_2_ascii,
a.name_2_ascii,
a.hasc_2,
1
FROM gadm_admin_2 a LEFT JOIN county_parish b
ON a.geonameid=b.county_parish_id
WHERE b.county_parish_id IS NULL
;

-- Fill in country by joining to country
UPDATE county_parish a
SET 
country_id=b.country_id,
country=b.country,
country_iso=b.iso
FROM country b
WHERE a.country_iso_alpha3=b.iso_alpha3
AND a.is_geoname=0
;

-- Fill in state_province_id by joining to state_province
-- on admin_1 hasc code
UPDATE county_parish a
SET 
state_province_id=b.state_province_id
FROM state_province b
WHERE a.hasc_1_full=b.hasc_full
AND a.is_geoname=0
;

-- Fill in state_province_id by joining to state_province
-- on alternate admin_1 hasc code
UPDATE county_parish a
SET 
state_province_id=b.state_province_id
FROM state_province b
WHERE a.hasc_1_full=REPLACE(b.state_province_code2_full,'-','.')
AND a.is_geoname=0
;


-- Fill in state_province by joining to state_province
-- on iso3 country code and state name
UPDATE county_parish a
SET 
state_province_id=b.state_province_id
FROM state_province b
WHERE 
a.country_iso_alpha3=b.country_iso_alpha3
AND (
a.state_province=b.state_province OR a.state_province_ascii=b.state_province_ascii
)
AND a.is_geoname=0
AND a.state_province_id IS NULL
;

-- Fill in state_province by joining to state_province
-- on iso2 country code and state name
UPDATE county_parish a
SET 
state_province_id=b.state_province_id
FROM state_province b
WHERE 
a.country_iso=b.country_iso
AND (
a.state_province=b.state_province OR a.state_province_ascii=b.state_province_ascii OR
a.state_province_ascii=b.state_province_std
)
AND a.is_geoname=0
AND a.state_province_id IS NULL
;

-- Fill in state_province by joining to state_province
-- on country and state name
UPDATE county_parish a
SET 
state_province_id=b.state_province_id
FROM state_province b
WHERE 
a.country=b.country
AND (
a.state_province=b.state_province OR a.state_province_ascii=b.state_province_ascii
)
AND a.is_geoname=0
AND a.state_province_id IS NULL
;

-- Delete counties that can't be linked to province
DELETE FROM county_parish
WHERE state_province_id IS NULL
;

--
-- Remove constraint and sequence 
--
ALTER TABLE IF EXISTS county_parish ALTER COLUMN county_parish_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS county_parish_county_parish_id_seq;
