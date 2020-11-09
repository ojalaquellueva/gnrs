-- ---------------------------------------------------------------
-- Fix missing gadm ID in poldiv tables
-- No idea why this is happening, need to check DB code
-- ---------------------------------------------------------------


--
-- state_province
-- 

-- back up just in case
DROP TABLE IF EXISTS state_province_bak;
CREATE TABLE state_province_bak ( LIKE state_province INCLUDING ALL);
INSERT INTO state_province_bak SELECT * FROM state_province;

-- Add column to track changes
ALTER TABLE state_province ADD COLUMN changed INT DEFAULT 0;

-- gid_0
UPDATE state_province a
SET gid_0=b.gid_0,
changed=1
FROM country b
WHERE a.country_id=b.country_id
AND a.gid_0 IS NULL
AND a.is_gadm=1
;

-- gid_1, exact match
UPDATE state_province a
SET gid_1=b.gid_1,
changed=2
FROM gadm_admin_1 b
WHERE a.state_province_id=b.geonameid
AND a.gid_1 IS NULL
AND a.is_gadm=1
;

-- gid_1, wildcard match
UPDATE state_province a
SET gid_1=b.gid_1,
changed=3
FROM gadm_admin_1 b
WHERE a.gid_0=b.gid_0
AND 
(
a.state_province_ascii LIKE  '%'  || b.name_1_ascii || '%' OR 
b.name_1_ascii LIKE '%'  || a.state_province_ascii || '%'
)
AND a.gid_1 IS NULL
AND a.is_gadm=1
;

-- Restore (if needed)
-- ALTER TABLE state_province RENAME TO state_province_fucked_up;
-- CREATE TABLE state_province ( LIKE state_province_bak INCLUDING ALL);
-- INSERT INTO state_province SELECT * FROM state_province_bak;

-- Remove backup tables
DROP TABLE IF EXISTS state_province_bak;
DROP TABLE IF EXISTS state_province_fucked_up;


--
-- county_parish
-- 

-- back up just in case
DROP TABLE IF EXISTS county_parish_bak;
CREATE TABLE county_parish_bak ( LIKE county_parish INCLUDING ALL);
INSERT INTO county_parish_bak SELECT * FROM county_parish;

-- Add column to track changes
ALTER TABLE county_parish ADD COLUMN changed INT DEFAULT 0;

-- gid_0 & gid_1
-- join by geonameid
UPDATE county_parish a
SET gid_0=b.gid_0,
gid_1=b.gid_1,
changed=1
FROM state_province b
WHERE a.state_province_id=b.state_province_id
AND (a.gid_0 IS NULL OR a.gid_1 IS NULL)
AND a.is_gadm=1
;

-- gid_0 & gid_1
-- join by wildcard state name
UPDATE county_parish a
SET gid_0=b.gid_0,
gid_1=b.gid_1,
changed=2
FROM state_province b
WHERE 
(
a.state_province_ascii LIKE  '%'  || b.state_province_ascii || '%' OR 
b.state_province_ascii LIKE '%'  || a.state_province_ascii || '%'
)
AND (a.gid_0 IS NULL OR a.gid_1 IS NULL)
AND a.is_gadm=1
;

-- gid_2, exact match
UPDATE county_parish a
SET gid_2=b.gid_2,
changed=3
FROM gadm_admin_2 b
WHERE a.county_parish_id=b.geonameid
AND a.gid_2 IS NULL
AND a.is_gadm=1
;

-- gid_1, wildcard match
UPDATE county_parish a
SET gid_2=b.gid_2,
changed=4
FROM gadm_admin_2 b
WHERE a.gid_0=b.gid_0 AND a.gid_1=b.gid_1
AND 
(
a.county_parish_ascii LIKE  '%'  || b.name_2_ascii || '%' OR 
b.name_2_ascii LIKE '%'  || a.county_parish_ascii || '%'
)
AND a.gid_2 IS NULL
AND a.is_gadm=1
;

-- Restore (if needed)
-- ALTER TABLE county_parish RENAME TO county_parish_fucked_up;
-- CREATE TABLE county_parish ( LIKE county_parish_bak INCLUDING ALL);
-- INSERT INTO county_parish SELECT * FROM county_parish_bak;


-- Remove backup tables
DROP TABLE IF EXISTS county_parish_bak;
DROP TABLE IF EXISTS county_parish_fucked_up;

