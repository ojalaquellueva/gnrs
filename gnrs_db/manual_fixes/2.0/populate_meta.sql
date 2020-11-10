-- ----------------------------------------------------------
-- Insert first record to table meta
-- ----------------------------------------------------------


INSERT INTO meta (
db_version,
code_version,
build_date
)
VALUES (
'0.1',
'0.1',
now()::date
);
