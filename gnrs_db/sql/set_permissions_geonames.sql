-- 
-- Assign database ownership to :user_adm while retaining ownership by postgres
-- Assign read-only access to :user_read
-- 

-- Full privileges
GRANT CONNECT ON DATABASE geonames TO :user_adm;
\c geonames
GRANT USAGE ON SCHEMA public TO :user_adm;
GRANT ALL PRIVILEGES ON TABLE country TO :user_adm;
GRANT ALL PRIVILEGES ON TABLE country_name TO :user_adm;
GRANT ALL PRIVILEGES ON TABLE state_province TO :user_adm;
GRANT ALL PRIVILEGES ON TABLE state_province_name TO :user_adm;
GRANT ALL PRIVILEGES ON TABLE county_parish TO :user_adm;
GRANT ALL PRIVILEGES ON TABLE county_parish_name TO :user_adm;

-- Read-only access
GRANT CONNECT ON DATABASE geonames TO :user_read;
\c geonames
GRANT USAGE ON SCHEMA public TO :user_read;
GRANT SELECT ON TABLE country TO :user_read;
GRANT SELECT ON TABLE country_name TO :user_read;
GRANT SELECT ON TABLE state_province TO :user_read;
GRANT SELECT ON TABLE state_province_name TO :user_read;
GRANT SELECT ON TABLE county_parish TO :user_read;
GRANT SELECT ON TABLE county_parish_name TO :user_read;
