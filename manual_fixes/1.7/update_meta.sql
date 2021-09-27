-- -------------------------------------------------------------
-- Update version information in table meta
-- -------------------------------------------------------------

/* Note:
HAS BEEN ADDED TO DB PIPELINE
*/

ALTER TABLE meta
ADD COLUMN version_comments text DEFAULT NULL
;


UPDATE meta
SET
db_version='2.2',
code_version='1.7',
build_date=now()::date,
version_comments='Includes country-as-state & state-as-country, with related bugfixes and backward-compatible database changes'
;