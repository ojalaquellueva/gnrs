-- 
-- Assign database ownership to :user_adm while retaining ownership by postgres
-- Assign read-only access to :user_read
-- 

-- Full privileges
GRANT USAGE ON SCHEMA public TO :user_adm;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO :user_adm;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO :user_adm;

-- Read-only access
GRANT USAGE ON SCHEMA public TO :user_read;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO :user_read;

