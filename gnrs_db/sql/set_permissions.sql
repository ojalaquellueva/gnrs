-- 
-- Assign full db privilege to :user_adm
-- 

-- Full privileges
GRANT CONNECT ON DATABASE :db TO :user_adm;
\c :db
GRANT USAGE ON SCHEMA public TO :user_adm;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO :user_adm;
