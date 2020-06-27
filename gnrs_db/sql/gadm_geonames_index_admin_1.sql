-- -----------------------------------------------------
-- Add geonameid to gadm admin 1
-- -----------------------------------------------------

-- For testing, clear in case re-running
UPDATE gadm_admin_1
SET geonameid=NULL
;


-- 
-- admin1_crosswalk: flag and remove any old/bad geonameid
-- 

ALTER TABLE admin1_crosswalk DROP COLUMN IF EXISTS bad_geonameid;
ALTER TABLE admin1_crosswalk
ADD COLUMN IF NOT EXISTS bad_geonameid INT default 1
;
UPDATE admin1_crosswalk a
SET bad_geonameid=0
FROM state_province b
WHERE a.gn_id=b.state_province_id
;
UPDATE admin1_crosswalk
SET bad_geonameid=0
WHERE gn_id IS NULL
;


-- UPDATE admin1_crosswalk
-- SET gn_id=NULL
-- WHERE bad_geonameid=1
-- ;


-- 
-- admin1_crosswalk: correct bad country codes for south sudan
-- 

UPDATE admin1_crosswalk a
SET adm0_a3='SSD',
adm1_code=REPLACE(adm1_code,'SDS-','SSD-')
WHERE admin='S. Sudan'
;

-- 
-- state_province: Add country iso_aplpha3 column if 
-- not already exists
-- 
ALTER TABLE state_province
ADD COLUMN IF NOT EXISTS country_iso_alpha3 text
;
UPDATE state_province a
SET country_iso_alpha3=b.iso_alpha3
FROM country b
WHERE a.country_id=b.country_id
;

-- 
-- state_province: Change '.' to '-' in state_province_code2_full
-- These are iso 3166-2 codes, not hasc codes
-- 
UPDATE state_province
SET state_province_code2_full=REPLACE(state_province_code2_full,'.','-')
;

-- 
-- admin1_crosswalk: Add plain ascii names 
-- 

-- name_0_ascii
ALTER TABLE admin1_crosswalk
ADD COLUMN IF NOT EXISTS name_ascii text
;
UPDATE admin1_crosswalk a
SET name_ascii=unaccent(name)
;

-- 
-- gadm_admin_1: Add country geonameids
-- 

ALTER TABLE gadm_admin_1
ADD COLUMN IF NOT EXISTS admin_0_geonameid integer
;
UPDATE gadm_admin_1 a
SET admin_0_geonameid=b.geonameid
FROM gadm_country b
WHERE a.gid_0=b.gid_0
;

-- 
-- state_province: Make FIPS codes same format as in admin1_crosswalk
-- column fips
-- 

ALTER TABLE state_province
ADD COLUMN IF NOT EXISTS fips_code_full text
;
UPDATE state_province a
SET fips_code_full=REPLACE(state_province_code_full,'.','')
;

-- 
-- gadm_admin_1: Add plain ascii names 
-- 

-- name_0_ascii
ALTER TABLE gadm_admin_1
ADD COLUMN IF NOT EXISTS name_0_ascii text
;
UPDATE gadm_admin_1 a
SET name_0_ascii=unaccent(name_0)
;

-- name_1_ascii
ALTER TABLE gadm_admin_1
ADD COLUMN IF NOT EXISTS name_1_ascii text
;
UPDATE gadm_admin_1 a
SET name_1_ascii=unaccent(name_1)
;

-- type_1_ascii
ALTER TABLE gadm_admin_1
ADD COLUMN IF NOT EXISTS type_1_ascii text
;
UPDATE gadm_admin_1 a
SET type_1_ascii=unaccent(type_1)
;

-- 
-- gadm_admin_1: Extract iso2 code from admin_1 hasc code
-- 

ALTER TABLE gadm_admin_1
ADD COLUMN IF NOT EXISTS country_iso text
;
UPDATE gadm_admin_1 a
SET country_iso=split_part(hasc_1,'.',1)
;

-- 
-- Add plain ascii names to gadm_admin_1
-- 

-- name_0_ascii
ALTER TABLE gadm_admin_1
ADD COLUMN IF NOT EXISTS name_0_ascii text
;
UPDATE gadm_admin_1 a
SET name_0_ascii=unaccent(name_0)
;

-- 
-- gadm_admin_1: Temporarily standardize country name to match 
-- bad geonames version
-- 

UPDATE gadm_admin_1 a
SET name_1_ascii='Mayagueez'
WHERE name_0='Puerto Rico'
AND name_1_ascii='Mayaguez'
;

-- 
-- state_province: Populate missing hasc codes by joining on crosswalk
-- 

UPDATE state_province a
SET hasc_full=b.code_hasc 
FROM admin1_crosswalk b
WHERE a.country_iso_alpha3=b.adm0_a3
AND a.state_province_id=b.gn_id
AND a.hasc_full IS NULL
;

-- 
-- Populate admin1 geonameid
-- Join directly to state_province
-- 

-- Join on hasc codes
UPDATE gadm_admin_1 a
SET geonameid=b.state_province_id
FROM state_province b
WHERE (a.gid_0=b.country_iso_alpha3 OR a.country_iso=b.country_iso)
AND a.hasc_1=b.hasc_full
AND a.geonameid IS NULL
;

-- Join on plain ascii name
UPDATE gadm_admin_1 a
SET geonameid=b.state_province_id
FROM state_province b
WHERE (a.gid_0=b.country_iso_alpha3 OR a.country_iso=b.country_iso)
AND a.name_1_ascii=b.state_province_ascii
AND a.geonameid IS NULL
;

-- Join on standard gnrs name
UPDATE gadm_admin_1 a
SET geonameid=b.state_province_id
FROM state_province b
WHERE (a.gid_0=b.country_iso_alpha3 OR a.country_iso=b.country_iso)
AND a.name_1_ascii=b.state_province_std
AND a.geonameid IS NULL
;

-- Join by geonames ascii name stripped of type
UPDATE gadm_admin_1 a
SET geonameid=b.state_province_id
FROM state_province b
WHERE (a.gid_0=b.country_iso_alpha3 OR a.country_iso=b.country_iso)
AND a.name_1_ascii=TRIM(REPLACE(b.state_province_std, a.type_1_ascii,''))
AND a.geonameid IS NULL
;

-- Same, wildcard match
UPDATE gadm_admin_1 a
SET geonameid=b.state_province_id
FROM state_province b
WHERE (a.gid_0=b.country_iso_alpha3 OR a.country_iso=b.country_iso)
AND a.name_1_ascii ILIKE '%'  || TRIM(REPLACE(b.state_province_std, a.type_1_ascii,''))  || '%'
AND a.geonameid IS NULL
;

-- wildcard match to standard gnrs name
UPDATE gadm_admin_1 a
SET geonameid=b.state_province_id
FROM state_province b
WHERE (a.gid_0=b.country_iso_alpha3 OR a.country_iso=b.country_iso)
AND (
a.name_1_ascii ILIKE '%'  || b.state_province_std || '%'
OR 
b.state_province_std ILIKE '%'  || a.name_1_ascii || '%'
)
AND a.geonameid IS NULL
;

-- 
-- Populate admin1 geonameid
-- Join to geonames via admin1_crosswalk
--

-- Join on hasc codes
UPDATE gadm_admin_1 a
SET geonameid=b.state_province_id
FROM (
SELECT y.state_province_id, 
y.country_iso_alpha3, y.country_iso, x.iso_a2, code_hasc,
x.name_ascii as crosswalk_name_ascii, y.state_province_ascii as geonames_name_ascii
FROM admin1_crosswalk x JOIN state_province y
ON x.adm0_a3=y.country_iso_alpha3  
AND (
x.iso_3166_2=y.state_province_code2_full OR
x.code_hasc=y.hasc_full OR
x.code_hasc=y.fips_code_full
)
) b
WHERE (a.gid_0=b.country_iso_alpha3 OR a.country_iso=b.country_iso OR a.country_iso=b.iso_a2)
AND a.hasc_1=b.code_hasc
AND a.geonameid IS NULL
;

-- Join to geonames on plain ascii name
UPDATE gadm_admin_1 a
SET geonameid=b.state_province_id
FROM (
SELECT y.state_province_id, 
y.country_iso_alpha3, y.country_iso, x.iso_a2, code_hasc,
x.name_ascii as crosswalk_name_ascii, y.state_province_ascii as geonames_name_ascii
FROM admin1_crosswalk x JOIN state_province y
ON x.adm0_a3=y.country_iso_alpha3  
AND (
x.iso_3166_2=y.state_province_code2_full OR
x.code_hasc=y.hasc_full OR
x.code_hasc=y.fips_code_full
)
) b
WHERE (a.gid_0=b.country_iso_alpha3 OR a.country_iso=b.country_iso OR a.country_iso=b.iso_a2)
AND a.name_0_ascii=b.geonames_name_ascii
AND a.geonameid IS NULL
;

-- Join to crosswalk on plain ascii name
UPDATE gadm_admin_1 a
SET geonameid=b.state_province_id
FROM (
SELECT y.state_province_id, 
y.country_iso_alpha3, y.country_iso, x.iso_a2, code_hasc,
x.name_ascii as crosswalk_name_ascii, y.state_province_ascii as geonames_name_ascii
FROM admin1_crosswalk x JOIN state_province y
ON x.adm0_a3=y.country_iso_alpha3  
AND (
x.iso_3166_2=y.state_province_code2_full OR
x.code_hasc=y.hasc_full OR
x.code_hasc=y.fips_code_full
)
) b
WHERE (a.gid_0=b.country_iso_alpha3 OR a.country_iso=b.country_iso OR a.country_iso=b.iso_a2)
AND a.name_0_ascii=b.crosswalk_name_ascii
AND a.geonameid IS NULL
;

-- 
-- Populate admin1 geonameid
-- Join directly to admin1_crosswalk
-- 
-- 
-- -- Join on hasc codes
-- UPDATE gadm_admin_1 a
-- SET geonameid=b.gn_id
-- FROM admin1_crosswalk b
-- WHERE a.gid_0=b.adm0_a3
-- AND a.hasc_1=b.code_hasc
-- AND a.geonameid IS NULL
-- AND b.gn_id>0
-- AND b.bad_geonameid=0
-- ;
-- 
-- -- Join on name
-- UPDATE gadm_admin_1 a
-- SET geonameid=b.gn_id
-- FROM admin1_crosswalk b
-- WHERE a.gid_0=b.adm0_a3
-- AND a.name_1_ascii=b.name_ascii
-- AND a.geonameid IS NULL
-- AND b.gn_id>0
-- AND b.bad_geonameid=0
-- ;

--
-- Remove pseudo-geonameids from crosswalk
--
UPDATE gadm_admin_1
SET geonameid=NULL
WHERE geonameid::integer<1
;

-- 
-- gadm_admin_1: Restore correct version of this Puerto Rico gadm_1 name
-- 

UPDATE gadm_admin_1 a
SET name_1_ascii='Mayaguez'
WHERE name_0='Puerto Rico'
AND name_1_ascii='Mayagueez'
;
