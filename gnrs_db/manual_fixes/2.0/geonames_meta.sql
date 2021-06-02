-- ----------------------------------------------------------
-- Create & populate temp table geonames meta. For testing loading
-- of table source. In production pipeline, this will be dumped as
-- table meta from DB geonames, which is then imported to 
-- DB gnrs and renamed to geonames_meta
-- ----------------------------------------------------------

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
