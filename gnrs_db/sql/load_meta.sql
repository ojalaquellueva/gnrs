-- -----------------------------------------------------------------
-- Create & populate main metadata table "meta"
-- -----------------------------------------------------------------

INSERT INTO meta (
db_version,
code_version,
build_date,
citation,
publication,
logo_path,
version_comments
) 
VALUES (
:'DB_VERSION',
:'VERSION',
now()::date,
CONCAT('@misc{gnrs, author = {Boyle, B. L. and Maitner, B. and Barbosa, G. C. and Enquist, B. J.}, journal = {Botanical Information and Ecology Network}, title = {Geographic Name Resolution Service}, year = ', to_char(now()::date, 'YYYY'), ', url = {https://gnrs.biendata.org/}, note = {Accessed ', to_char(now()::date, 'Mon DD, YYYY'), '}}'),
NULL,
'images/gnrs.png',
:'VERSION_COMMENTS'
);
