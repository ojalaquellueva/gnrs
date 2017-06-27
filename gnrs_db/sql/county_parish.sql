-- -----------------------------------------------------------------
-- Creates and populates county_parish tables in gnrs database -----------------------------------------------------------------

-- 
-- country: one row per county_parish, official name and codes
--

DROP TABLE IF EXISTS county_parish;
CREATE TABLE county_parish AS (
SELECT geonameid,
CAST(NULL AS TEXT) AS country,
countrycode,
CAST(NULL AS TEXT) AS state_province,
CAST(NULL AS TEXT) AS state_province_ascii,
admin1,
name AS county_parish,
asciiname AS county_parish_ascii,
admin2,
fclass,
fcode,
latitude,
longitude
FROM geoname
WHERE fclass='A' AND fcode='ADM2'
ORDER BY countrycode, admin1, name
);

ALTER TABLE county_parish ADD PRIMARY KEY (geonameid);
CREATE INDEX ON county_parish (county_parish);
CREATE INDEX ON county_parish (countrycode);
CREATE INDEX ON county_parish (county_parish_ascii);
CREATE INDEX ON county_parish (admin1);
CREATE INDEX ON county_parish (admin2);

-- Populate state_province name to make tale more readable
UPDATE county_parish a
SET 
state_province=b.state_province,
state_province_ascii=b.state_province_ascii,
country=b.country
FROM state_province b
WHERE a.countrycode=b.countrycode
AND a.admin1=b.admin1
;

-- Populate country for county/parish with missing state_province
UPDATE county_parish a
SET country=b.country
FROM countries b
WHERE a.countrycode=b.iso
AND a.country IS NULL
;

CREATE INDEX ON county_parish (state_province);
CREATE INDEX ON county_parish (state_province_ascii);
CREATE INDEX ON county_parish (country);

