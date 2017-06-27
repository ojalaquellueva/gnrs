-- -----------------------------------------------------------------
-- Creates and populates state_province tables in gnrs database -----------------------------------------------------------------

-- 
-- country: one row per state_province, official name and codes
--

DROP TABLE IF EXISTS state_province CASCADE;
CREATE TABLE state_province AS (
SELECT geonameid,
CAST(NULL AS TEXT) AS country,
country AS country_iso,
name AS state_province,
asciiname AS state_province_ascii,
admin1 as code
FROM geoname
WHERE fclass='A' AND fcode='ADM1'
ORDER BY country, admin1
);

ALTER TABLE ONLY state_province ADD CONSTRAINT state_province_pkey PRIMARY KEY (geonameid);
CREATE INDEX state_province_country_idx ON state_province USING btree (country);
CREATE INDEX state_province_country_iso_idx ON state_province USING btree (country_iso);
CREATE INDEX state_province_state_province_ascii_idx ON state_province USING btree (state_province_ascii);
CREATE INDEX state_province_code_idx ON state_province USING btree (code);

-- Populate full plain ascii country name
UPDATE state_province a
SET country=b.country
FROM country b
WHERE a.country_iso=b.iso
;

-- 
-- state_province_name: state_province alternate names
-- 

DROP TABLE IF EXISTS state_province_name;
CREATE TABLE state_province_name (
state_province_name_id BIGSERIAL PRIMARY KEY,
geonameid BIGINT,
state_province_name TEXT,
is_preferred_name_en INTEGER NOT NULL DEFAULT 0,
is_official_name INTEGER NOT NULL DEFAULT 0,
is_official_name_ascii INTEGER NOT NULL DEFAULT 0
);

DROP TABLE IF EXISTS state_province_name_temp;
CREATE TABLE state_province_name_temp AS (
SELECT DISTINCT
a.geonameid,
a.alternatename AS state_province_name
FROM alternatename a JOIN country b
ON a.geonameid=b.geonameid
WHERE a.isolanguage<>'link'
);

INSERT INTO state_province_name_temp (
geonameid,
state_province_name
)
SELECT DISTINCT
a.geonameid,
a.name
FROM geoname a JOIN country b
ON a.geonameid=b.geonameid
;

INSERT INTO state_province_name_temp (
geonameid,
state_province_name
)
SELECT DISTINCT
a.geonameid,
a.asciiname
FROM geoname a JOIN country b
ON a.geonameid=b.geonameid
;

INSERT INTO state_province_name (
geonameid,
state_province_name
)
SELECT DISTINCT
geonameid,
state_province_name
FROM state_province_name_temp
ORDER BY geonameid, state_province_name
;

DROP TABLE state_province_name_temp;

CREATE INDEX state_province_name_geonameid_idx ON state_province_name USING btree (geonameid);
CREATE INDEX state_province_name_state_province_name_idx ON state_province_name USING btree (state_province_name);
CREATE INDEX state_province_name_is_preferred_name_en_idx ON state_province_name USING btree (is_preferred_name_en);
CREATE INDEX state_province_name_is_official_name_idx ON state_province_name USING btree (is_official_name);
CREATE INDEX state_province_name_is_official_name_ascii_idx ON state_province_name USING btree (is_official_name_ascii);
ALTER TABLE ONLY state_province_name 
	ADD CONSTRAINT state_province_name_geonameid_fkey FOREIGN KEY (geonameid) 
	REFERENCES country(geonameid);
	
-- Flag official names (verbatim & ascii)
UPDATE state_province_name a
SET is_official_name=1
FROM geoname b
WHERE a.geonameid=b.geonameid
AND a.state_province_name=b.name
;

UPDATE state_province_name a
SET is_official_name_ascii=1
FROM geoname b
WHERE a.geonameid=b.geonameid
AND a.state_province_name=b.asciiname
;

