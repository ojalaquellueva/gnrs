-- ----------------------------------------------------------
-- Create & populate temp table gadm_meta. For testing loading
-- of table source. In production pipeline, this will be dumped as
-- table meta from DB gadm, which is then imported to 
-- DB gnrs and renamed to gadm_meta
-- ----------------------------------------------------------

DROP TABLE IF EXISTS gadm_meta;
CREATE TABLE gadm_meta (
version text,
data_uri text,
data_version text,
date_accessed timestamp
);

INSERT INTO gadm_meta (
version,
data_uri, 
data_version, 
date_accessed
)
VALUES (
'3.6', 
'https://biogeo.ucdavis.edu/data/gadm3.6/gadm36_gpkg.zip', 
'3.6', 
'2020-04-15 17:34:00'
);
