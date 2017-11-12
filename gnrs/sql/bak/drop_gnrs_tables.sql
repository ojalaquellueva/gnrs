-- ----------------------------------------
-- Drops GNRS tables in geonames database
-- Must run as postgres
-- ----------------------------------------

DROP TABLE IF EXISTS country CASCADE;
DROP TABLE IF EXISTS country_code;
DROP TABLE IF EXISTS country_name;

DROP TABLE IF EXISTS state_province CASCADE;
DROP TABLE IF EXISTS state_province_name;


DROP TABLE IF EXISTS county_parish CASCADE;
DROP TABLE IF EXISTS county_parish_name;