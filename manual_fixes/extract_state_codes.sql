-- ----------------------------------------------------------
-- Queries to extract admin1 (state) codes for manual alignment of
-- GADM and Geonames political divisions
-- ----------------------------------------------------------

-- 
-- GADM
-- 

\c gadm

\COPY (SELECT DISTINCT gid_0, name_0, gid_1, id_1, name_1, hasc_1, cc_1, type_1, engtype_1 from gadm_nospatial order by name_0, name_1 asc)  TO '/home/boyle/bien/gnrs/data/db/gadm_states.csv' csv header;

-- 
-- Geonames
-- 

\c geonames

\COPY (select distinct a.geonameid,  a.country as countrycode_iso2,  ctry.name as country, a.cc2,  b.name, b.nameascii, a.name as fullname,  a.asciiname as fullnameascii,  a.admin1, c.admin1code as admin1code, c.admin1code_full, b.code as admin1code_full_numeric from geoname a LEFT JOIN  ( SELECT DISTINCT country, name FROM geoname WHERE  fclass='A' AND fcode='PCLI' ) ctry ON a.country=ctry.country LEFT JOIN admin1codesascii b ON a.geonameid=b.geonameid LEFT JOIN postalcodes c ON b.name=c.admin1name where a.fclass='A' AND a.fcode='ADM1' order by a.country, b.nameascii)  TO '/home/boyle/bien/gnrs/data/db/geonames_states.csv' csv header;


