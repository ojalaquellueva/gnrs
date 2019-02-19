-- -----------------------------------------------------------------
-- Creates and populates county_parish tables in gnrs database -----------------------------------------------------------------

-- 
-- country: one row per county_parish, official name and codes
--

DROP TABLE IF EXISTS county_parish CASCADE;
CREATE TABLE county_parish AS (
SELECT geonameid AS county_parish_id,
CAST(NULL AS TEXT) AS country,
trim(country) AS country_iso,
CAST(NULL AS BIGINT) AS country_id,
CAST(NULL AS BIGINT) AS state_province_id,
CAST(NULL AS TEXT) AS state_province,
CAST(NULL AS TEXT) AS state_province_ascii,
trim(admin1) AS state_province_code,
trim(name) AS county_parish,
trim(asciiname) AS county_parish_ascii,
trim(admin2) AS county_parish_code,
CAST(NULL AS TEXT) AS county_parish_code_full,
CAST(NULL AS TEXT) AS hasc_2,
CAST(NULL AS TEXT) AS hasc_2_full
FROM geoname
WHERE fclass='A' AND fcode='ADM2'
ORDER BY country, admin1, name
);

ALTER TABLE county_parish ADD PRIMARY KEY (county_parish_id);
CREATE INDEX ON county_parish (county_parish);
CREATE INDEX ON county_parish (country_iso);
CREATE INDEX ON county_parish (state_province_code);
CREATE INDEX ON county_parish (county_parish);
CREATE INDEX ON county_parish (county_parish_ascii);
CREATE INDEX ON county_parish (county_parish_code);

-- Populate country and state_province names
UPDATE county_parish a
SET 
country_id=b.country_id,
state_province_id=b.state_province_id,
state_province=b.state_province,
state_province_ascii=b.state_province_ascii,
country=b.country
FROM state_province b
WHERE a.country_iso=b.country_iso
AND a.state_province_code=b.state_province_code
;

-- Populate country for county/parishes with missing state_province
UPDATE county_parish a
SET country=b.country
FROM country b
WHERE a.country_iso=b.iso
AND a.country IS NULL
;

-- Populate county parish iso codes
UPDATE county_parish a
SET county_parish_code_full=b.code
FROM admin2codesascii b
WHERE a.county_parish_id=b.geonameid
;

-- Add remaining indexes
CREATE INDEX ON county_parish (country_id);
CREATE INDEX ON county_parish (state_province_id);
CREATE INDEX ON county_parish (county_parish_code_full);
CREATE INDEX ON county_parish (hasc_2);
CREATE INDEX ON county_parish (hasc_2_full);
CREATE INDEX ON county_parish (country);
CREATE INDEX ON county_parish (state_province);
CREATE INDEX ON county_parish (state_province_ascii);

-- 
-- county_parish_name: alternate names
-- 

DROP TABLE IF EXISTS county_parish_name;
CREATE TABLE county_parish_name (
county_parish_name_id BIGSERIAL PRIMARY KEY,
county_parish_id BIGINT,
county_parish_name TEXT,
is_preferred_name_en INTEGER NOT NULL DEFAULT 0,
is_official_name INTEGER NOT NULL DEFAULT 0,
is_official_name_ascii INTEGER NOT NULL DEFAULT 0
);

DROP TABLE IF EXISTS county_parish_name_temp;
CREATE TABLE county_parish_name_temp AS (
SELECT DISTINCT
a.geonameid AS county_parish_id,
a.alternatename AS county_parish_name
FROM alternatename a JOIN county_parish b
ON a.geonameid=b.county_parish_id
WHERE a.isolanguage<>'link'
);

INSERT INTO county_parish_name_temp (
county_parish_id,
county_parish_name
)
SELECT DISTINCT
a.geonameid,
a.name
FROM geoname a JOIN county_parish b
ON a.geonameid=b.county_parish_id
;

INSERT INTO county_parish_name_temp (
county_parish_id,
county_parish_name
)
SELECT DISTINCT
a.geonameid,
a.asciiname
FROM geoname a JOIN county_parish b
ON a.geonameid=b.county_parish_id
;

INSERT INTO county_parish_name (
county_parish_id,
county_parish_name
)
SELECT DISTINCT
county_parish_id,
county_parish_name
FROM county_parish_name_temp
ORDER BY county_parish_id, county_parish_name
;

DROP TABLE county_parish_name_temp;

CREATE INDEX county_parish_name_county_parish_id_idx ON county_parish_name USING btree (county_parish_id);
CREATE INDEX county_parish_name_county_parish_name_idx ON county_parish_name USING btree (county_parish_name);
CREATE INDEX county_parish_name_is_preferred_name_en_idx ON county_parish_name USING btree (is_preferred_name_en);
CREATE INDEX county_parish_name_is_official_name_idx ON county_parish_name USING btree (is_official_name);
CREATE INDEX county_parish_name_is_official_name_ascii_idx ON county_parish_name USING btree (is_official_name_ascii);
ALTER TABLE ONLY county_parish_name 
	ADD CONSTRAINT county_parish_name_county_parish_id_fkey FOREIGN KEY (county_parish_id) 
	REFERENCES county_parish(county_parish_id);
	
-- Flag official names (verbatim & ascii)
UPDATE county_parish_name a
SET is_official_name=1
FROM geoname b
WHERE a.county_parish_id=b.geonameid
AND a.county_parish_name=b.name
;

UPDATE county_parish_name a
SET is_official_name_ascii=1
FROM geoname b
WHERE a.county_parish_id=b.geonameid
AND a.county_parish_name=b.asciiname
;


