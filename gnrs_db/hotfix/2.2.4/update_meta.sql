-- -----------------------------------------------------------------------
-- Add updated citations. Not yet added to pipeline, although bibtex files
-- have been added to ../data/db/gnrs/
-- -----------------------------------------------------------------------

/*
Make changes to all instances:
Private development: gnrs_dev on vegbiendev
Public development: gnrs_2_2 on vegbiendev
Production: gnrs_2_2 on paramo
*/

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
'2.2.4',
'Minor updates to GNRS citations',
'2024-04-02',
'1.7.3',
'Add fuzzy match threshold option to shell interface and API',
'2022-02-02',
'@misc{gnrs.app, author = {Boyle, B. L. and Maitner, B. and Barbosa, G. C. and Rethvick, S. Y. B. and Enquist, B. J.}, journal = {Botanical Information and Ecology Network}, title = {Geographic Name Resolution Service}, year = {2024}, url = {https://tnrs.biendata.org/}, note = {Accessed <date_of_access>} }',
'@article{gnrs.pub, doi = {10.1371/journal.pone.0268162}, author = {Boyle, Bradley L. AND Maitner, Brian S. AND Barbosa, George G. C. AND Sajja, Rohith K. AND Feng, Xiao AND Merow, Cory AND Newman, Erica A. AND Park, Daniel S. AND Roehrdanz, Patrick R. AND Enquist, Brian J.}, journal = {PLOS ONE}, publisher = {Public Library of Science}, title = {Geographic name resolution service: A tool for the standardization and indexing of world political division names, with applications to species distribution modeling}, year = {2022}, month = {11}, volume = {17}, url = {https://doi.org/10.1371/journal.pone.0268162}, pages = {1-18}, number = {11}, }',
'images/gnrs.png'
);
