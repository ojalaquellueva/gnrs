-- -----------------------------------------------------------------
-- Create & populate main metadata table "meta"
-- -----------------------------------------------------------------

INSERT INTO meta (
db_version,
code_version,
build_date
) 
VALUES (
:'DB_VERSION',
:'VERSION',
now()::date
);



