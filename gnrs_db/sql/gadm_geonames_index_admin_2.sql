-- -----------------------------------------------------
-- Add geonameid to gadm admin 2 (county)
-- -----------------------------------------------------

--
-- gadm_admin_2: some custom fixes
--

-- Affects Mexico and Colombia only
UPDATE gadm_admin_2
SET name_2=REPLACE(name_2, 'Dist. ', '')
WHERE name_2 LIKE '%Dist. %'
;
UPDATE gadm_admin_2
SET name_2='Huajuapan'
WHERE name_2='Huajuapam'
AND name_1 LIKE '%Oaxaca%'
AND name_0='Mexico'
;

-- 
-- county_parish: Add iso_aplpha3 column if not already exists
-- 

ALTER TABLE county_parish
ADD COLUMN IF NOT EXISTS country_iso_alpha3 text
;
UPDATE county_parish a
SET country_iso_alpha3=b.iso_alpha3
FROM country b
WHERE a.country_id=b.country_id
;

-- 
-- state_province: Change '.' to '-' in state_province_code2_full
-- and county_parish_code2_full. These are iso 3166-2 codes, not hasc codes;
-- 

UPDATE county_parish
SET 
state_province_code2_full=REPLACE(state_province_code2_full,'.','-'),
county_parish_code2_full=REPLACE(county_parish_code2_full,'.','-')
;

-- 
-- gadm_admin_2: Add country & admin_1 geonameids 
-- 

ALTER TABLE gadm_admin_2
ADD COLUMN IF NOT EXISTS admin_0_geonameid integer,
ADD COLUMN IF NOT EXISTS admin_1_geonameid integer
;
UPDATE gadm_admin_2 a
SET admin_0_geonameid=b.geonameid
FROM gadm_country b
WHERE a.gid_0=b.gid_0
;
UPDATE gadm_admin_2 a
SET admin_1_geonameid=b.geonameid
FROM gadm_admin_1 b
WHERE a.gid_0=b.gid_0
AND a.gid_1=b.gid_1
;

-- 
-- gadm_admin_2: Add plain ascii names 
-- 

ALTER TABLE gadm_admin_2
ADD COLUMN IF NOT EXISTS name_0_ascii text,
ADD COLUMN IF NOT EXISTS name_1_ascii text,
ADD COLUMN IF NOT EXISTS name_2_ascii text,
ADD COLUMN IF NOT EXISTS type_2_ascii text
;
UPDATE gadm_admin_2 a
SET 
name_0_ascii=unaccent(name_0),
name_1_ascii=unaccent(name_1),
name_2_ascii=unaccent(name_2),
type_2_ascii=unaccent(type_2)
;

-- 
-- gadm_admin_2: Extract iso2 code from admin_1 hasc code
-- 

ALTER TABLE gadm_admin_2
ADD COLUMN IF NOT EXISTS country_iso text
;
UPDATE gadm_admin_2 a
SET country_iso=split_part(hasc_1,'.',1)
;

-- 
-- Populate gadm_admin_1 geonameid
-- Join directly to county_parish
-- 

-- Join on hasc codes
-- Doesn't work yet because no hasc code in geonames!
UPDATE gadm_admin_2 a
SET geonameid=b.county_parish_id
FROM county_parish b
WHERE a.admin_0_geonameid=b.country_id
AND a.admin_1_geonameid=b.state_province_id
AND a.hasc_2=b.hasc_2_full
AND a.geonameid IS NULL
;

-- Join on plain ascii name
UPDATE gadm_admin_2 a
SET geonameid=b.county_parish_id
FROM county_parish b
WHERE a.admin_0_geonameid=b.country_id
AND a.admin_1_geonameid=b.state_province_id
AND a.name_2_ascii=b.county_parish_ascii
AND a.geonameid IS NULL
;

-- Join on plain ascii name name stripped of type
UPDATE gadm_admin_2 a
SET geonameid=b.county_parish_id
FROM county_parish b
WHERE a.admin_0_geonameid=b.country_id
AND a.admin_1_geonameid=b.state_province_id
AND a.name_2_ascii=TRIM(REPLACE(b.county_parish_ascii, a.type_2_ascii,''))
AND a.geonameid IS NULL
;

-- Fuzzy match to plain ascii name
-- WARNING: might generate a few false positives
UPDATE gadm_admin_2 a
SET geonameid=b.county_parish_id
FROM county_parish b
WHERE a.admin_0_geonameid=b.country_id
AND a.admin_1_geonameid=b.state_province_id
AND 
(
a.name_2_ascii ILIKE '%'  || b.county_parish_ascii || '%'
OR 
b.county_parish_ascii ILIKE '%'  || a.name_2_ascii || '%'
)
AND a.geonameid IS NULL
;

-- Join on standard gnrs name
UPDATE gadm_admin_2 a
SET geonameid=b.county_parish_id
FROM county_parish b
WHERE a.admin_0_geonameid=b.country_id
AND a.admin_1_geonameid=b.state_province_id
AND a.name_2_ascii=b.county_parish_std
AND a.geonameid IS NULL
;

-- Join on standard gnrs name name stripped of type
UPDATE gadm_admin_2 a
SET geonameid=b.county_parish_id
FROM county_parish b
WHERE a.admin_0_geonameid=b.country_id
AND a.admin_1_geonameid=b.state_province_id
AND a.name_2_ascii=TRIM(REPLACE(b.county_parish_std, a.type_2_ascii,''))
AND a.geonameid IS NULL
;

-- Fuzzy match to standard gnrs name
-- WARNING: might generate a few false positives
UPDATE gadm_admin_2 a
SET geonameid=b.county_parish_id
FROM county_parish b
WHERE a.admin_0_geonameid=b.country_id
AND a.admin_1_geonameid=b.state_province_id
AND 
(
a.name_2_ascii ILIKE '%'  || b.county_parish_std || '%'
OR 
b.county_parish_std ILIKE '%'  || a.name_2_ascii || '%'
)
AND a.geonameid IS NULL
;

--
-- Remove pseudo-geonameids from crosswalk
--
UPDATE gadm_admin_2
SET geonameid=NULL
WHERE geonameid<1
;
