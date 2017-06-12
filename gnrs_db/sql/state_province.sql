DROP TABLE IF EXISTS state_province;
CREATE TABLE state_province AS (
SELECT geonameid,
CAST(NULL AS TEXT) AS country,
country AS country_code,
name AS state_province,
asciiname AS state_province_ascii,
admin1,
fclass,
fcode,
latitude,
longitude
FROM geoname
WHERE fclass='A' AND fcode='ADM1'
ORDER BY country, admin1
);

ALTER TABLE state_province ADD PRIMARY KEY (geonameid);
CREATE INDEX ON state_province (state_province);
CREATE INDEX ON state_province (countrycode);
CREATE INDEX ON state_province (state_province_ascii);
CREATE INDEX ON state_province (admin1);

UPDATE state_province a
SET country=b.country
FROM countries b
WHERE a.countrycode=b.iso
;

CREATE INDEX ON state_province (country);
