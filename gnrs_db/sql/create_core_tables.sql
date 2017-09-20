-- -----------------------------------------------------------------
-- Creates all remaining tables not derived from geonames
-- -----------------------------------------------------------------

DROP TABLE IF EXISTS user_data;
CREATE TABLE user_data (
id BIGSERIAL NOT NULL PRIMARY KEY,
country_verbatim VARCHAR(50) DEFAULT '',
state_province_verbation VARCHAR(100) DEFAULT '',
county_parish_verbatim VARCHAR(100) DEFAULT '',
country VARCHAR(50) DEFAULT '',
state_province VARCHAR(100) DEFAULT '',
county_parish VARCHAR(100) DEFAULT '',
country_geonameid INTEGER DEFAULT NULL,
state_province_geonameid INTEGER DEFAULT NULL,
county_parish_geonameid INTEGER DEFAULT NULL,
poldiv_submitted VARCHAR(50) DEFAULT NULL, 
poldiv_matched VARCHAR(50) DEFAULT NULL,
user_id BIGINT DEFAULT NULL
) 
;

DROP TABLE IF EXISTS cache;
CREATE TABLE cache (
id BIGSERIAL NOT NULL PRIMARY KEY,
country_verbatim VARCHAR(50) DEFAULT '',
state_province_verbation VARCHAR(100) DEFAULT '',
county_parish_verbatim VARCHAR(100) DEFAULT '',
country VARCHAR(50) DEFAULT '',
state_province VARCHAR(100) DEFAULT '',
county_parish VARCHAR(100) DEFAULT '',
country_geonameid INTEGER DEFAULT NULL,
state_province_geonameid INTEGER DEFAULT NULL,
county_parish_geonameid INTEGER DEFAULT NULL,
poldiv_submitted VARCHAR(50) DEFAULT NULL, 
poldiv_matched VARCHAR(50) DEFAULT NULL
) 
;