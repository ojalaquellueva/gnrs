-- 
-- Assign database ownership to :user while retaining ownership by postgres
-- 

GRANT CONNECT ON DATABASE geonames TO :user;
\c geonames
GRANT USAGE ON SCHEMA public TO :user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO :user;
