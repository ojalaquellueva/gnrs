-- -----------------------------------------------------------------------
-- Alters structure of table meta to include "id" primary key, thereby 
-- allowing retention of information on previous versions.
-- 
-- New structure has been added to DB pipeline. However, pipeline still 
-- needs to be modified to allow carry-forward of information from 
-- previous meta table when database is rebuilt from scratch.
-- -----------------------------------------------------------------------

/*
Make changes to all instances:
Private development: gnrs_dev on vegbiendev
Public development: gnrs_2_2 on vegbiendev
Production: gnrs_2_2 on paramo
*/

ALTER TABLE meta
ADD COLUMN id SERIAL NOT NULL PRIMARY KEY
;

INSERT INTO meta (
db_version,
db_version_comments,
db_version_build_date,
code_version,
code_version_comments,
code_version_release_date,
citation,
publication,
logo_path
) 
VALUES (
'2.2.3',
'Minor schema changes: add column threshold_fuzzy table user_data; add PK to table meta',
'2022-02-02',
'1.7.3',
'Add fuzzy match threshold option to shell interface and API',
'2022-02-02',
'@misc{gnrs, author = {Boyle, B. L. and Maitner, B. and Barbosa, G. C. and Enquist, B. J.}, journal = {Botanical Information and Ecology Network}, title = {Geographic Name Resolution Service}, year = 2021, url = {https://gnrs.biendata.org/}, note = {Accessed Jun 02, 2021}}',
NULL,
'images/gnrs.png'
);
