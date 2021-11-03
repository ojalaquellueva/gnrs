-- ----------------------------------------------------------
-- Create & populate temp tables gadm_meta and geonames_meta. For testing loading
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

DROP TABLE IF EXISTS geonames_meta;
CREATE TABLE geonames_meta (
version text,
data_uri text,
data_version text,
date_accessed timestamp
);

INSERT INTO geonames_meta (
version,
data_uri, 
data_version, 
date_accessed
)
VALUES (
'2.0', 
'http://download.geonames.org/export/dump', 
'2020-04-21', 
'2020-04-21 00:00:00'
);

ALTER TABLE gadm_meta OWNER TO bien;
ALTER TABLE geonames_meta OWNER TO bien;
