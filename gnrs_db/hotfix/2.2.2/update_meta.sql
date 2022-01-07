-- -----------------------------------------------------------------------
-- Alters structure of table meta to store separate release dates and 
-- comments for database and code. 
-- -----------------------------------------------------------------------


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
'2.2.2',
'Minor changes to metadata table only. Keeping build date of DB version 2.2.1)',
'2021-11-03',
'1.7.2',
'Fixed bug stateascountry (caused some countries to be resolved to name of former minor territories)',
'2022-01-07',
'@misc{gnrs, author = {Boyle, B. L. and Maitner, B. and Barbosa, G. C. and Enquist, B. J.}, journal = {Botanical Information and Ecology Network}, title = {Geographic Name Resolution Service}, year = 2021, url = {https://gnrs.biendata.org/}, note = {Accessed Jun 02, 2021}}',
NULL,
'images/gnrs.png'
);
