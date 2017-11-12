-- -----------------------------------------------------------------
-- Creates all remaining tables not derived from geonames
-- -----------------------------------------------------------------

DROP TABLE IF EXISTS user_data;
CREATE TABLE user_data (
id BIGSERIAL NOT NULL PRIMARY KEY,
poldiv_full text NOT NULL,
country_verbatim VARCHAR(50) DEFAULT '',
state_province_verbatim VARCHAR(100) DEFAULT '',
county_parish_verbatim VARCHAR(100) DEFAULT '',
country VARCHAR(50) DEFAULT NULL,
state_province VARCHAR(100) DEFAULT NULL,
county_parish VARCHAR(100) DEFAULT NULL,
country_id INTEGER DEFAULT NULL,
state_province_id INTEGER DEFAULT NULL,
county_parish_id INTEGER DEFAULT NULL,
match_method_country VARCHAR(50) DEFAULT NULL,
match_method_state_province VARCHAR(50) DEFAULT NULL,
match_method_county_parish VARCHAR(50) DEFAULT NULL,
match_score_country NUMERIC(4,2) DEFAULT NULL,
match_score_state_province NUMERIC(4,2) DEFAULT NULL,
match_score_county_parish NUMERIC(4,2) DEFAULT NULL,
poldiv_submitted VARCHAR(50) DEFAULT NULL, 
poldiv_matched VARCHAR(50) DEFAULT NULL,
user_id BIGINT DEFAULT NULL
) 
;
