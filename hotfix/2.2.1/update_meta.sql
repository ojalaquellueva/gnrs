-- ----------------------------------------------------------
-- Update version info in table meta
--
-- REPEAT FOR ALL INSTANCES!
-- ----------------------------------------------------------

\c gnrs_2_2

DROP TABLE IF EXISTS meta_temp;
CREATE TABLE meta_temp (LIKE meta INCLUDING ALL);
INSERT INTO meta_temp SELECT * FROM meta;

UPDATE meta_temp
SET 
db_version='2.2.1',
code_version='1.7.1',
build_date=now()::date,
version_comments='Minor update: fix incorrect values of gid_0 for South Sudan'
;

DROP TABLE meta;
ALTER TABLE meta_temp RENAME TO meta;