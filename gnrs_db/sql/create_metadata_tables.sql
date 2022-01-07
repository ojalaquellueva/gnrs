-- -----------------------------------------------------------------
-- Create & populate metadata tables
-- -----------------------------------------------------------------

DROP TABLE IF EXISTS meta;
CREATE TABLE meta (
db_version TEXT DEFAULT NULL,
db_version_comments TEXT DEFAULT NULL,
db_version_build_date date,
code_version TEXT DEFAULT NULL,
code_version_comments TEXT DEFAULT NULL,
code_version_release_date date,
citation TEXT DEFAULT NULL,
publication TEXT DEFAULT NULL,
logo_path TEXT DEFAULT NULL 
);

DROP TABLE IF EXISTS source;
CREATE TABLE source (
source_id SERIAL NOT NULL PRIMARY KEY,
source_name TEXT NOT NULL,
source_name_full TEXT DEFAULT NULL,
source_url TEXT DEFAULT NULL,
description TEXT DEFAULT NULL,
data_url TEXT DEFAULT NULL,
source_version TEXT DEFAULT NULL,
source_release_date DATE DEFAULT NULL,
date_accessed DATE DEFAULT NULL,
citation TEXT DEFAULT NULL,
logo_path TEXT DEFAULT NULL
);

DROP TABLE IF EXISTS collaborator;
CREATE TABLE collaborator (
collaborator_id SERIAL NOT NULL PRIMARY KEY,
collaborator_name TEXT DEFAULT NULL,
collaborator_name_full TEXT DEFAULT NULL,
collaborator_url TEXT DEFAULT NULL,
description TEXT DEFAULT NULL,
logo_path TEXT DEFAULT NULL
);
