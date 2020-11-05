-- --------------------------------------------------------------
-- Adds & populates gadm country, state and county level
-- political division ids (gid_0, gid_1 and gid_2, respectively)
-- in gnrs political division tables
-- 
-- Should be done earlier, but adding later for now until I have 
-- time to integrate all scripts
-- --------------------------------------------------------------


ALTER TABLE country
ADD COLUMN IF NOT EXISTS gid_0 text DEFAULT NULL
;
UPDATE country a
SET gid_0=b.gid_0
FROM gadm_country b
WHERE a.country_id=b.geonameid
;
DROP INDEX IF EXISTS country_gid_0_idx;
CREATE INDEX country_gid_0_idx ON country(gid_0);

ALTER TABLE state_province
ADD COLUMN IF NOT EXISTS gid_0 text DEFAULT NULL,
ADD COLUMN IF NOT EXISTS gid_1 text DEFAULT NULL
;
UPDATE state_province a
SET 
gid_0=b.gid_0,
gid_1=b.gid_1
FROM gadm_admin_1 b
WHERE a.state_province_id=b.geonameid
;
DROP INDEX IF EXISTS state_province_gid_0_idx;
DROP INDEX IF EXISTS state_province_gid_1_idx;
CREATE INDEX state_province_gid_0_idx ON state_province(gid_0);
CREATE INDEX state_province_gid_1_idx ON state_province(gid_1);


ALTER TABLE county_parish
ADD COLUMN IF NOT EXISTS gid_0 text DEFAULT NULL,
ADD COLUMN IF NOT EXISTS gid_1 text DEFAULT NULL,
ADD COLUMN IF NOT EXISTS gid_2 text DEFAULT NULL
;
UPDATE county_parish a
SET 
gid_0=b.gid_0,
gid_1=b.gid_1,
gid_2=b.gid_2
FROM gadm_admin_2 b
WHERE a.county_parish_id=b.geonameid
;
DROP INDEX IF EXISTS county_parish_gid_0_idx;
DROP INDEX IF EXISTS county_parish_gid_1_idx;
DROP INDEX IF EXISTS county_parish_gid_2_idx;
CREATE INDEX county_parish_gid_0_idx ON county_parish(gid_0);
CREATE INDEX county_parish_gid_1_idx ON county_parish(gid_1);
CREATE INDEX county_parish_gid_2_idx ON county_parish(gid_2);


