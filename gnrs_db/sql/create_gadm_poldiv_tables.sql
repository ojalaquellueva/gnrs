-- ----------------------------------------------------------------
-- Create tables of verbatim GADM political division names
-- ----------------------------------------------------------------

DROP TABLE IF EXISTS gadm_country;
CREATE TABLE gadm_country AS
SELECT DISTINCT 
gid_0,
name_0,
NULL::integer AS geonameid
FROM gadm
WHERE name_0 IS NOT NULL
ORDER BY name_0
;
CREATE UNIQUE INDEX ON gadm_country (gid_0);
CREATE UNIQUE INDEX ON gadm_country (name_0);

DROP TABLE IF EXISTS gadm_admin_1;
CREATE TABLE gadm_admin_1 AS
SELECT DISTINCT 
gid_0,
name_0, 
gid_1,
hasc_1,
name_1,
engtype_1,
type_1,
NULL::integer AS geonameid
FROM gadm
WHERE name_0 IS NOT NULL
AND name_1 IS NOT NULL
ORDER BY name_0, name_1 NULLS FIRST
;
CREATE INDEX ON gadm_admin_1 (gid_0);
CREATE INDEX ON gadm_admin_1 (name_0);
CREATE UNIQUE INDEX ON gadm_admin_1 (name_0, name_1);
CREATE UNIQUE INDEX ON gadm_admin_1 (gid_1);
CREATE INDEX ON gadm_admin_1 (hasc_1); -- Not unique

DROP TABLE IF EXISTS gadm_admin_2;
CREATE TABLE gadm_admin_2 AS
SELECT DISTINCT 
gid_0,
name_0, 
gid_1,
hasc_1,
name_1,
engtype_1,
type_1,
gid_2,
hasc_2,
name_2,
type_2,
engtype_2,
NULL::integer AS geonameid
FROM gadm
WHERE name_0 IS NOT NULL
AND name_1 IS NOT NULL
AND name_2 IS NOT NULL
ORDER BY name_0, name_1, name_2 NULLS FIRST
;
CREATE INDEX ON gadm_admin_2 (gid_0);
CREATE INDEX ON gadm_admin_2 (name_0);
CREATE INDEX ON gadm_admin_2 (gid_1);
CREATE INDEX ON gadm_admin_2 (hasc_1);
CREATE INDEX ON gadm_admin_2 (name_0, name_1);
CREATE UNIQUE INDEX ON gadm_admin_2 (name_0, name_1, name_2);
CREATE INDEX ON gadm_admin_2 (gid_1); -- Not unique
CREATE INDEX ON gadm_admin_2 (hasc_2); -- Not unique
