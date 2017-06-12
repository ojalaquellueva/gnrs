-- -----------------------------------------------------------------
-- Creates and populates tables state_province and county_parish in
-- database geoscrub
-- -----------------------------------------------------------------

-- 
-- country
--

DROP TABLE IF EXISTS country CASCADE;
CREATE TABLE country AS (
SELECT 
geonameid,
country,
iso_alpha2 AS iso,
iso_alpha3 AS iso_alpha3,
fips_code AS fips
FROM countryinfo
ORDER BY country
);

ALTER TABLE ONLY country ADD CONSTRAINT country_pkey PRIMARY KEY (geonameid);
CREATE INDEX country_country_idx ON country USING btree (country);
CREATE INDEX country_iso_idx ON country USING btree (iso);
CREATE INDEX country_iso_alpha3_idx ON country USING btree (iso_alpha3);
CREATE INDEX country_fips_idx ON country USING btree (fips);

-- 
-- country_code
--
-- WARNING: need to flag countries with duplicate codes! 
-- Note the following:
-- select b.code, geonameid, country from country_code a JOIN (select code, count(distinct country) as countries from country_code group by code having  count(distinct country)>1) as b on a.code=b.code;

-- Country ISO codes
DROP TABLE IF EXISTS country_code_temp;
CREATE TABLE country_code_temp AS (
SELECT 
geonameid,
country,
CAST(iso AS TEXT) AS code,
CAST('iso' AS TEXT) AS code_type
FROM country
WHERE iso IS NOT NULL
);

-- Country FIPS codes
INSERT INTO country_code_temp (
geonameid,
country,
code,
code_type
)
SELECT 
geonameid,
country,
fips,
'fips' AS code_type
FROM country
WHERE fips IS NOT NULL
;

-- Country ISO3 codes
INSERT INTO country_code_temp (
geonameid,
country,
code,
code_type
)
SELECT 
geonameid,
country,
iso_alpha3,
'iso_alpha3' AS code_type
FROM country
WHERE iso_alpha3 IS NOT NULL
;

DROP TABLE IF EXISTS country_code;
CREATE TABLE country_code (
country_code_id SERIAL PRIMARY KEY,
geonameid BIGINT NOT NULL,
country TEXT,
code character varying(6),
code_type character varying(25)
);

INSERT INTO country_code (
geonameid,
country,
code,
code_type
)
SELECT DISTINCT 
geonameid,
country,
code,
code_type
FROM country_code_temp
ORDER BY country, geonameid, code
;

DROP TABLE country_code_temp;

CREATE INDEX country_code_geonameid_idx ON country_code USING btree (geonameid);
CREATE INDEX country_code_country_idx ON country_code USING btree (country);
CREATE INDEX country_code_code_idx ON country_code USING btree (code);
CREATE INDEX country_code_code_type_idx ON country_code USING btree (code_type);
ALTER TABLE ONLY country_code 
	ADD CONSTRAINT country_code_geonameid_fkey FOREIGN KEY (geonameid) 
	REFERENCES country(geonameid); 
	
-- 
-- country_name
-- 

DROP TABLE IF EXISTS country_name;
CREATE TABLE country_name (
country_name_id BIGSERIAL PRIMARY KEY,
geonameid BIGINT,
country_name TEXT,
is_preferred_name_en INTEGER NOT NULL DEFAULT 0,
is_official_name INTEGER NOT NULL DEFAULT 0,
is_official_name_ascii INTEGER NOT NULL DEFAULT 0
);

DROP TABLE IF EXISTS country_name_temp;
CREATE TABLE country_name_temp AS (
SELECT DISTINCT
a.geonameid,
a.alternatename AS country_name
FROM alternatename a JOIN country b
ON a.geonameid=b.geonameid
WHERE a.isolanguage<>'link'
);

INSERT INTO country_name_temp (
geonameid,
country_name
)
SELECT DISTINCT
a.geonameid,
a.name
FROM geoname a JOIN country b
ON a.geonameid=b.geonameid
;

INSERT INTO country_name_temp (
geonameid,
country_name
)
SELECT DISTINCT
a.geonameid,
a.asciiname
FROM geoname a JOIN country b
ON a.geonameid=b.geonameid
;

INSERT INTO country_name (
geonameid,
country_name
)
SELECT DISTINCT
geonameid,
country_name
FROM country_name_temp
ORDER BY geonameid, country_name
;

DROP TABLE country_name_temp;

UPDATE country_name a
SET is_official_name=1
FROM geoname b
WHERE a.geonameid=b.geonameid
AND a.country_name=b.name
;

UPDATE country_name a
SET is_official_name_ascii=1
FROM geoname b
WHERE a.geonameid=b.geonameid
AND a.country_name=b.asciiname
;

CREATE INDEX country_name_geonameid_idx ON country_name USING btree (geonameid);
CREATE INDEX country_name_country_name_idx ON country_name USING btree (country_name);
CREATE INDEX country_name_is_preferred_name_en_idx ON country_name USING btree (is_preferred_name_en);
CREATE INDEX country_name_is_official_name_idx ON country_name USING btree (is_official_name);
CREATE INDEX country_name_is_official_name_ascii_idx ON country_name USING btree (is_official_name_ascii);
ALTER TABLE ONLY country_name 
	ADD CONSTRAINT country_name_geonameid_fkey FOREIGN KEY (geonameid) 
	REFERENCES country(geonameid);