-- -----------------------------------------------------------------
-- Populate data source metadata table "source"
-- -----------------------------------------------------------------

-- Geonames
INSERT INTO source (
source_id,
source_name,
source_name_full,
source_url,
description,
data_url,
source_version,
source_release_date,
date_accessed,
citation,
logo_path
)
SELECT 
1,
'geonames',
'GeoNames geographical database',
'www.geonames.org',
'The GeoNames geographical database covers all countries and contains over eleven million placenames that are available for download free of charge.',
data_uri,
data_version,
date_accessed,
date_accessed,
CONCAT('@misc{geonames, author= {{Geonames}}, title = {Geonames}, url = {https://www.geonames.org/}, note = {Accessed ', to_char(date_accessed::date, 'Mon DD, YYYY'), '}}'),
'images/geonames.png'
FROM geonames_meta
;

-- GADM
INSERT INTO source (
source_id,
source_name,
source_name_full,
source_url,
description,
data_url,
source_version,
source_release_date,
date_accessed,
citation,
logo_path
)
SELECT 
2,
'GADM',
'Database of Global Administrative Areas',
'https://gadm.org/',
'GADM, the Database of Global Administrative Areas, is a high-resolution database of country administrative areas, with a goal of "all countries, at all levels, at any time period.',
data_uri,
data_version,
date_accessed::date,
date_accessed::date,
CONCAT('@misc{gadm, author= {{University of California, Berkeley, Museum of Vertebrate Zoolog}}, title = {Global Administrative Areas}, url = {https://gadm.org/}, note = {Accessed ', to_char(date_accessed::date, 'Mon DD, YYYY'), '}}'),
'images/gadm.png'
FROM gadm_meta
;

-- Natural Earth
INSERT INTO source (
source_id,
source_name,
source_name_full,
source_url,
description,
data_url,
source_version,
source_release_date,
date_accessed,
citation,
logo_path
)
VALUES ( 
3,
'Natural Earth',
'Natural Earth Data',
'https://www.naturalearthdata.com/',
'Lookup tables of admin 1 (state/province) names and codes. From Natural Earth Data, ',
'https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip',
'4.1.0',
now()::date,
now()::date,
CONCAT('@misc{naturalearth, author= {Kelse, Nathaniel Vaughn and Patterson, Tom and Furno, Dick and Buckingham, Tanya and Springer, Nick and Cross, Louis}, title = {Natural Earth}, year = ', to_char(now()::date, 'YYYY'), ', url = {https://www.naturalearthdata.com/}, note = {Accessed ', to_char(now()::date, 'Mon DD, YYYY'), '}}'),
'images/natearth.png'
)
;
