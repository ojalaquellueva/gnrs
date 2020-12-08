-- -----------------------------------------------------------------
-- Creates and populates state_province tables in gnrs database -----------------------------------------------------------------

-- 
-- state_province: one row per state_province, official name and codes
--

DROP TABLE IF EXISTS state_province CASCADE;
CREATE TABLE state_province AS (
SELECT geonameid as state_province_id,
CAST(NULL AS TEXT) AS country,
CAST(NULL AS BIGINT) AS country_id,
trim(country) AS country_iso,
trim(name) AS state_province,
trim(asciiname) AS state_province_ascii,
trim(admin1) as state_province_code,
CAST(NULL AS TEXT) AS state_province_code_full,
CAST(NULL AS TEXT) AS hasc,
CAST(NULL AS TEXT) AS hasc_full
FROM geoname
WHERE fclass='A' AND fcode='ADM1'
ORDER BY country, admin1
);

ALTER TABLE ONLY state_province ADD CONSTRAINT state_province_pkey PRIMARY KEY (state_province_id);
CREATE INDEX state_province_country_idx ON state_province USING btree (country);
CREATE INDEX state_province_country_iso_idx ON state_province USING btree (country_iso);

-- Populate full plain ascii country name
UPDATE state_province a
SET country=b.country,
country_id=b.country_id
FROM country b
WHERE a.country_iso=b.iso
;

-- Populate state province codes
UPDATE state_province a
SET state_province_code_full=b.code
FROM admin1codesascii b
WHERE a.state_province_id=b.geonameid
;


-- Add remaining indexes
CREATE INDEX state_province_country_id_idx ON state_province USING btree (country_id);
CREATE INDEX state_province_state_province_ascii_idx ON state_province USING btree (state_province_ascii);
CREATE INDEX state_province_state_province_code_idx ON state_province USING btree (state_province_code);
CREATE INDEX state_province_state_province_code_full_idx ON state_province USING btree (state_province_code_full);
CREATE INDEX state_province_state_province_ci_idx ON state_province USING btree (LOWER(state_province));
CREATE INDEX state_province_state_province_ascii_ci_idx ON state_province USING btree (LOWER(state_province_ascii));

-- 
-- state_province_name: state_province alternate names
-- 

DROP TABLE IF EXISTS state_province_name;
CREATE TABLE state_province_name (
state_province_name_id BIGSERIAL PRIMARY KEY,
state_province_id BIGINT,
state_province_name TEXT,
is_preferred_name_en INTEGER NOT NULL DEFAULT 0,
is_official_name INTEGER NOT NULL DEFAULT 0,
is_official_name_ascii INTEGER NOT NULL DEFAULT 0
);

DROP TABLE IF EXISTS state_province_name_temp;
CREATE TABLE state_province_name_temp AS (
SELECT DISTINCT
a.geonameid AS state_province_id,
a.alternatename AS state_province_name
FROM alternatename a JOIN state_province b
ON a.geonameid=b.state_province_id
WHERE a.isolanguage<>'link'
);

INSERT INTO state_province_name_temp (
state_province_id,
state_province_name
)
SELECT DISTINCT
a.geonameid,
a.name
FROM geoname a JOIN state_province b
ON a.geonameid=b.state_province_id
;

INSERT INTO state_province_name_temp (
state_province_id,
state_province_name
)
SELECT DISTINCT
a.geonameid,
a.asciiname
FROM geoname a JOIN state_province b
ON a.geonameid=b.state_province_id
;

INSERT INTO state_province_name (
state_province_id,
state_province_name
)
SELECT DISTINCT
state_province_id,
state_province_name
FROM state_province_name_temp
ORDER BY state_province_id, state_province_name
;

DROP TABLE state_province_name_temp;

-- Add remaining indexes
CREATE INDEX state_province_name_state_province_id_idx ON state_province_name USING btree (state_province_id);
CREATE INDEX state_province_name_state_province_name_idx ON state_province_name USING btree (state_province_name);
CREATE INDEX state_province_name_is_preferred_name_en_idx ON state_province_name USING btree (is_preferred_name_en);
CREATE INDEX state_province_name_is_official_name_idx ON state_province_name USING btree (is_official_name);
CREATE INDEX state_province_name_is_official_name_ascii_idx ON state_province_name USING btree (is_official_name_ascii);

-- Add FKS
ALTER TABLE ONLY state_province_name 
	ADD CONSTRAINT state_province_name_state_province_id_fkey FOREIGN KEY (state_province_id) 
	REFERENCES state_province(state_province_id);
	
-- Flag official names (verbatim & ascii)
UPDATE state_province_name a
SET is_official_name=1
FROM geoname b
WHERE a.state_province_id=b.geonameid
AND a.state_province_name=b.name
;

UPDATE state_province_name a
SET is_official_name_ascii=1
FROM geoname b
WHERE a.state_province_id=b.geonameid
AND a.state_province_name=b.asciiname
;

