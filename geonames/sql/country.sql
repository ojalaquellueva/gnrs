-- -----------------------------------------------------------------
-- Creates and populates country tables in gnrs database -----------------------------------------------------------------

-- 
-- country: one row per country, official name and codes
--

DROP TABLE IF EXISTS country CASCADE;
CREATE TABLE country AS (
SELECT 
geonameid AS country_id,
country,
iso_alpha2 AS iso,
iso_alpha3 AS iso_alpha3,
fips_code AS fips
FROM countryinfo
ORDER BY country
);

ALTER TABLE ONLY country ADD CONSTRAINT country_pkey PRIMARY KEY (country_id);
CREATE INDEX country_country_idx ON country USING btree (country);
CREATE INDEX country_iso_idx ON country USING btree (iso);
CREATE INDEX country_iso_alpha3_idx ON country USING btree (iso_alpha3);
CREATE INDEX country_fips_idx ON country USING btree (fips);

-- 
-- country_code: all codes for a country, one row per code, duplicates flagged
--
-- WARNING: Note the following:
-- select b.code, geonameid, country from country_code a JOIN (select code, count(distinct country) as countries from country_code group by code having  count(distinct country)>1) as b on a.code=b.code;

-- Country ISO codes
DROP TABLE IF EXISTS country_code_temp;
CREATE TABLE country_code_temp AS (
SELECT 
country_id,
country,
CAST(iso AS TEXT) AS code,
CAST('iso' AS TEXT) AS code_type
FROM country
WHERE iso IS NOT NULL
);

-- Country FIPS codes
INSERT INTO country_code_temp (
country_id,
country,
code,
code_type
)
SELECT 
country_id,
country,
fips,
'fips' AS code_type
FROM country
WHERE fips IS NOT NULL
;

-- Country ISO3 codes
INSERT INTO country_code_temp (
country_id,
country,
code,
code_type
)
SELECT 
country_id,
country,
iso_alpha3,
'iso_alpha3' AS code_type
FROM country
WHERE iso_alpha3 IS NOT NULL
;

DROP TABLE IF EXISTS country_code;
CREATE TABLE country_code (
country_code_id SERIAL PRIMARY KEY,
country_id BIGINT NOT NULL,
country TEXT,
code character varying(6),
code_type character varying(25),
is_unique integer NOT NULL DEFAULT 1
);

INSERT INTO country_code (
country_id,
country,
code,
code_type
)
SELECT DISTINCT 
country_id,
country,
code,
code_type
FROM country_code_temp
ORDER BY country, country_id, code
;

DROP TABLE country_code_temp;

CREATE INDEX country_code_geonameid_idx ON country_code USING btree (country_id);
CREATE INDEX country_code_country_idx ON country_code USING btree (country);
CREATE INDEX country_code_code_idx ON country_code USING btree (code);
CREATE INDEX country_code_code_type_idx ON country_code USING btree (code_type);
ALTER TABLE ONLY country_code 
	ADD CONSTRAINT country_code_country_id_fkey FOREIGN KEY (country_id) 
	REFERENCES country(country_id); 
	
-- Flag non-unique codes
UPDATE country_code a 
SET is_unique=0
FROM (
SELECT code, COUNT(DISTINCT country) AS countries 
FROM country_code 
GROUP BY code 
HAVING COUNT(DISTINCT country)>1
) AS b 
WHERE a.code=b.code
;
	
-- 
-- country_name: country alternate names
-- 

DROP TABLE IF EXISTS country_name;
CREATE TABLE country_name (
country_name_id BIGSERIAL PRIMARY KEY,
country_id BIGINT,
country_name TEXT,
is_preferred_name_en INTEGER NOT NULL DEFAULT 0,
is_official_name INTEGER NOT NULL DEFAULT 0,
is_official_name_ascii INTEGER NOT NULL DEFAULT 0
);

DROP TABLE IF EXISTS country_name_temp;
CREATE TABLE country_name_temp AS (
SELECT DISTINCT
a.geonameid AS country_id,
a.alternatename AS country_name
FROM alternatename a JOIN country b
ON a.geonameid=b.country_id
WHERE a.isolanguage<>'link'
);

INSERT INTO country_name_temp (
country_id,
country_name
)
SELECT DISTINCT
a.geonameid,
a.name
FROM geoname a JOIN country b
ON a.geonameid=b.country_id
;

INSERT INTO country_name_temp (
country_id,
country_name
)
SELECT DISTINCT
a.geonameid,
a.asciiname
FROM geoname a JOIN country b
ON a.geonameid=b.country_id
;

INSERT INTO country_name (
country_id,
country_name
)
SELECT DISTINCT
country_id,
country_name
FROM country_name_temp
ORDER BY country_id, country_name
;

DROP TABLE country_name_temp;

CREATE INDEX country_name_country_id_idx ON country_name USING btree (country_id);
CREATE INDEX country_name_country_name_idx ON country_name USING btree (country_name);
CREATE INDEX country_name_is_preferred_name_en_idx ON country_name USING btree (is_preferred_name_en);
CREATE INDEX country_name_is_official_name_idx ON country_name USING btree (is_official_name);
CREATE INDEX country_name_is_official_name_ascii_idx ON country_name USING btree (is_official_name_ascii);
ALTER TABLE ONLY country_name 
	ADD CONSTRAINT country_name_country_id_fkey FOREIGN KEY (country_id) 
	REFERENCES country(country_id);