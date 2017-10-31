-- 
-- Create raw data table
-- 

DROP TABLE IF EXISTS :tbl;
CREATE TABLE :tbl (
centroid_lat text,
centroid_lon text,
uncertainty_lat text,
uncertainty_lon text,
max_uncertainty text,
country text,
state text,
county text,
units text,
projection text
);
