-- -----------------------------------------------------------------
-- Creates all remaining tables not derived from geonames
-- -----------------------------------------------------------------

DROP TABLE IF EXISTS meta;
CREATE TABLE meta (
db_version text DEFAULT NULL,
code_version text DEFAULT NULL,
build_date date
);

DROP TABLE IF EXISTS user_data_raw;
CREATE TABLE user_data_raw (
job text NOT NULL,
user_id text DEFAULT NULL,
country text DEFAULT NULL,
state_province text DEFAULT NULL,
county_parish text DEFAULT NULL
);


DROP TABLE IF EXISTS user_data;
CREATE TABLE user_data (
id BIGSERIAL NOT NULL PRIMARY KEY,
job text DEFAULT NULL,
poldiv_full text DEFAULT NULL,
country_verbatim text DEFAULT '',
state_province_verbatim text DEFAULT '',
state_province_verbatim_alt text DEFAULT '',
county_parish_verbatim text DEFAULT '',
county_parish_verbatim_alt text DEFAULT '',
country VARCHAR(250) DEFAULT NULL,
state_province VARCHAR(250) DEFAULT NULL,
county_parish VARCHAR(250) DEFAULT NULL,
country_id INTEGER DEFAULT NULL,
state_province_id INTEGER DEFAULT NULL,
county_parish_id INTEGER DEFAULT NULL,
country_iso VARCHAR(50)  DEFAULT NULL,
state_province_iso VARCHAR(50)  DEFAULT NULL,
county_parish_iso VARCHAR(50)  DEFAULT NULL,
geonameid text DEFAULT NULL,
gid_0 text DEFAULT NULL,
gid_1 text DEFAULT NULL,
gid_2 text DEFAULT NULL,
match_method_country VARCHAR(50) DEFAULT NULL,
match_method_state_province VARCHAR(50) DEFAULT NULL,
match_method_county_parish VARCHAR(50) DEFAULT NULL,
match_score_country NUMERIC(4,2) DEFAULT NULL,
match_score_state_province NUMERIC(4,2) DEFAULT NULL,
match_score_county_parish NUMERIC(4,2) DEFAULT NULL,
overall_score NUMERIC(4,2) DEFAULT NULL, 
poldiv_submitted VARCHAR(50) DEFAULT NULL, 
poldiv_matched VARCHAR(50) DEFAULT NULL,
match_status VARCHAR(50) DEFAULT NULL,
is_in_cache SMALLINT DEFAULT 0,
user_id text DEFAULT NULL
) 
;

DROP TABLE IF EXISTS cache;
CREATE TABLE cache (
id BIGSERIAL NOT NULL PRIMARY KEY,
poldiv_full text DEFAULT NULL,
country_verbatim text DEFAULT '',
state_province_verbatim text DEFAULT '',
state_province_verbatim_alt text DEFAULT '',
county_parish_verbatim text DEFAULT '',
county_parish_verbatim_alt text DEFAULT '',
country VARCHAR(250) DEFAULT NULL,
state_province VARCHAR(250) DEFAULT NULL,
county_parish VARCHAR(250) DEFAULT NULL,
country_id INTEGER DEFAULT NULL,
state_province_id INTEGER DEFAULT NULL,
county_parish_id INTEGER DEFAULT NULL,
country_iso VARCHAR(50)  DEFAULT NULL,
state_province_iso VARCHAR(50)  DEFAULT NULL,
county_parish_iso VARCHAR(50)  DEFAULT NULL,
geonameid text DEFAULT NULL,
gid_0 text DEFAULT NULL,
gid_1 text DEFAULT NULL,
gid_2 text DEFAULT NULL,
match_method_country VARCHAR(50) DEFAULT NULL,
match_method_state_province VARCHAR(50) DEFAULT NULL,
match_method_county_parish VARCHAR(50) DEFAULT NULL,
match_score_country NUMERIC(4,2) DEFAULT NULL,
match_score_state_province NUMERIC(4,2) DEFAULT NULL,
match_score_county_parish NUMERIC(4,2) DEFAULT NULL,
overall_score NUMERIC(4,2) DEFAULT NULL, 
poldiv_submitted VARCHAR(50) DEFAULT NULL, 
poldiv_matched VARCHAR(50) DEFAULT NULL,
match_status VARCHAR(50) DEFAULT NULL
) 
;