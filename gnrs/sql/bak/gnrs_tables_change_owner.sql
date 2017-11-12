-- 
-- Reassign ownership of gnrs tables to postgres
-- Must run as postgres
-- 

ALTER TABLE country OWNER TO postgres;
ALTER TABLE country_name OWNER TO postgres;
ALTER TABLE state_province OWNER TO postgres;
ALTER TABLE state_province_name OWNER TO postgres;
ALTER TABLE county_parish OWNER TO postgres;
ALTER TABLE county_parish_name OWNER TO postgres;
