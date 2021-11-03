-- ----------------------------------------------------------
-- Insert first record to table meta
-- ----------------------------------------------------------


INSERT INTO meta (
db_version,
code_version,
build_date,
version_comments
)
VALUES (
'2.0',
'2.0',
now()::date,
NULL
);
