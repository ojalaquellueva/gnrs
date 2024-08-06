/*
Hotfix for GitHub issue #17 "The phrase 'region' seems to be missing from scrubbed 'county_parish' names". 
*/

\c gnrs_dev
/* 
-- Repeat for public development DB on vegbiendev:
\c gnrs_2_2
-- Repeat for production DB on paramo:
\c gnrs_2_2_3
*/


--
-- Confirm issue
--

-- View one affected record
-- Note that only field county_parish_std is affected
\x
SELECT * FROM county_parish WHERE county_parish_std ILIKE 'al District %' LIMIT 1;
/*
gnrs_dev=# SELECT * FROM county_parish WHERE county_parish_std ILIKE 'al District %' LIMIT 1;
-[ RECORD 1 ]-------------+---------------------------------------
county_parish_id          | 6119133
country                   | Canada
country_iso               | CA
country_id                | 6251999
state_province_id         | 5909050
state_province            | British Columbia
state_province_ascii      | British Columbia
state_province_code       | 02
county_parish             | Regional District of Kootenay-Boundary
county_parish_ascii       | Regional District of Kootenay-Boundary
county_parish_code        | 5905
county_parish_code_full   | CA.02.5905
hasc_2                    | 
hasc_2_full               | 
county_parish_std         | al District of Kootenay-Boundary
state_province_code2      | BC
state_province_code2_full | CA-BC
county_parish_code2       | 
county_parish_code2_full  | 
country_iso_alpha3        | CAN
hasc_1_full               | 
hasc_1_full_alt           | 
is_geoname                | 1
is_gadm                   | 0
gid_0                     | 
gid_1                     | 
gid_2                     | 
changed                   | 0
is_stateascounty          | 0
*/
\x

-- List original and corrupted fields of all affected records
SELECT county_parish, county_parish_std
FROM county_parish
WHERE county_parish_std ILIKE 'al District %'
;
/*
               county_parish               |          county_parish_std          
-------------------------------------------+-------------------------------------
 Regional District of Kootenay-Boundary    | al District of Kootenay-Boundary
 Regional District of Alberni-Clayoquot    | al District of Alberni-Clayoquot
 Regional District of Bulkley-Nechako      | al District of Bulkley-Nechako
 Regional District of Central Kootenay     | al District of Central Kootenay
 Regional District of Central Okanagan     | al District of Central Okanagan
 Regional District of East Kootenay        | al District of East Kootenay
 Regional District of Fraser-Fort George   | al District of Fraser-Fort George
 Regional District of Kitimat-Stikine      | al District of Kitimat-Stikine
 Regional District of Mount Waddington     | al District of Mount Waddington
 Regional District of Nanaimo              | al District of Nanaimo
 Regional District of North Okanagan       | al District of North Okanagan
 Regional District of Okanagan-Similkameen | al District of Okanagan-Similkameen
(12 rows)
*/

-- But note that suffixes are also affected:
SELECT county_parish, county_parish_std
FROM county_parish
WHERE county_parish ILIKE '%Regional District%'
;
/*
               county_parish               |          county_parish_std          
-------------------------------------------+-------------------------------------
 Regional District of Kootenay-Boundary    | al District of Kootenay-Boundary
 Strathcona Regional District              | Strathcona Regional
 Comox Valley Regional District            | Comox Valley Regional
 Capital Regional District                 | Capital Regional
 Cariboo Regional District                 | Cariboo Regional
 Central Coast Regional District           | Central Coast Regional
 Columbia-Shuswap Regional District        | Columbia-Shuswap Regional
 Cowichan Valley Regional District         | Cowichan Valley Regional
 Fraser Valley Regional District           | Fraser Valley Regional
 Greater Vancouver Regional District       | Greater Vancouver Regional
 Peace River Regional District             | Peace River Regional
 Powell River Regional District            | Powell River Regional
 Regional District of Alberni-Clayoquot    | al District of Alberni-Clayoquot
 Regional District of Bulkley-Nechako      | al District of Bulkley-Nechako
 Regional District of Central Kootenay     | al District of Central Kootenay
 Regional District of Central Okanagan     | al District of Central Okanagan
 Regional District of East Kootenay        | al District of East Kootenay
 Regional District of Fraser-Fort George   | al District of Fraser-Fort George
 Regional District of Kitimat-Stikine      | al District of Kitimat-Stikine
 Regional District of Mount Waddington     | al District of Mount Waddington
 Regional District of Nanaimo              | al District of Nanaimo
 Regional District of North Okanagan       | al District of North Okanagan
 Regional District of Okanagan-Similkameen | al District of Okanagan-Similkameen
 Skeena-Queen Charlotte Regional District  | Skeena-Queen Charlotte Regional
 Squamish-Lillooet Regional District       | Squamish-Lillooet Regional
 Sunshine Coast Regional District          | Sunshine Coast Regional
 Thompson-Nicola Regional District         | Thompson-Nicola Regional
(27 rows)
*/

-- View one affected record with 'Regional District' suffix
-- Note that only field county_parish_std is affected
\x
SELECT * FROM county_parish WHERE county_parish ILIKE '%Regional District' LIMIT 1;
/*
gnrs_dev=# SELECT * FROM county_parish WHERE county_parish_std ILIKE 'al District %' LIMIT 1;
-[ RECORD 1 ]-------------+-----------------------------
county_parish_id          | 8593707
country                   | Canada
country_iso               | CA
country_id                | 6251999
state_province_id         | 5909050
state_province            | British Columbia
state_province_ascii      | British Columbia
state_province_code       | 02
county_parish             | Strathcona Regional District
county_parish_ascii       | Strathcona Regional District
county_parish_code        | 5924
county_parish_code_full   | CA.02.5924
hasc_2                    | 
hasc_2_full               | 
county_parish_std         | Strathcona Regional
state_province_code2      | BC
state_province_code2_full | CA-BC
county_parish_code2       | 
county_parish_code2_full  | 
country_iso_alpha3        | CAN
hasc_1_full               | 
hasc_1_full_alt           | 
is_geoname                | 1
is_gadm                   | 0
gid_0                     | 
gid_1                     | 
gid_2                     | 
changed                   | 0
is_stateascounty          | 0
*/
/* Confirms that only county_parish_std is affected */
\x

-- Get final count of all affected rows:
SELECT COUNT(*) FROM county_parish WHERE county_parish ILIKE '%Regional District%';
/*
 count 
-------
    27
(1 row)
*/

--
-- Test proposed fixes
--

-- 'Regional District of' prefix
SELECT county_parish, county_parish_std,
regexp_replace(county_parish, 'Regional District of ', '', 'i') AS county_parish_std_fixed
FROM county_parish
WHERE county_parish ILIKE 'Regional District of %'
;
/*

*/

-- ' Regional District' suffix
SELECT county_parish, county_parish_std,
regexp_replace(county_parish, ' Regional District', '', 'i') AS county_parish_std_fixed
FROM county_parish
WHERE county_parish ILIKE '% Regional District'
;
/*
              county_parish               |        county_parish_std        | county_parish_std_fixed 
------------------------------------------+---------------------------------+-------------------------
 Strathcona Regional District             | Strathcona Regional             | Strathcona
 Comox Valley Regional District           | Comox Valley Regional           | Comox Valley
 Capital Regional District                | Capital Regional                | Capital
 Cariboo Regional District                | Cariboo Regional                | Cariboo
 Central Coast Regional District          | Central Coast Regional          | Central Coast
 Columbia-Shuswap Regional District       | Columbia-Shuswap Regional       | Columbia-Shuswap
 Cowichan Valley Regional District        | Cowichan Valley Regional        | Cowichan Valley
 Fraser Valley Regional District          | Fraser Valley Regional          | Fraser Valley
 Greater Vancouver Regional District      | Greater Vancouver Regional      | Greater Vancouver
 Peace River Regional District            | Peace River Regional            | Peace River
 Powell River Regional District           | Powell River Regional           | Powell River
 Skeena-Queen Charlotte Regional District | Skeena-Queen Charlotte Regional | Skeena-Queen Charlotte
 Squamish-Lillooet Regional District      | Squamish-Lillooet Regional      | Squamish-Lillooet
 Sunshine Coast Regional District         | Sunshine Coast Regional         | Sunshine Coast
 Thompson-Nicola Regional District        | Thompson-Nicola Regional        | Thompson-Nicola
(15 rows)
*/


--
-- Back up
--

-- Reset "changed" flag
UPDATE county_parish SET changed=0 WHERE NOT changed=0;

CREATE TABLE county_parish_bak (LIKE county_parish INCLUDING ALL);
INSERT INTO county_parish_bak SELECT * FROM county_parish;

-- Verify relevant rows identical in both tables (EXCEPT method)
SELECT
	county_parish_id, 
	country,
	state_province,
	county_parish, 
	county_parish_std, 
	'not in county_parish_bak' AS note 
FROM county_parish 
EXCEPT 
SELECT 
	county_parish_id, 
	country,
	state_province,
	county_parish, 
	county_parish_std, 
	'not in county_parish_bak' AS note 
FROM county_parish_bak
UNION
SELECT 
	county_parish_id, 
	country,
	state_province,
	county_parish, 
	county_parish_std, 
	'not in county_parish' AS note 
FROM county_parish_bak 
EXCEPT 
SELECT 
	county_parish_id, 
	country,
	state_province,
	county_parish, 
	county_parish_std, 
	'not in county_parish' AS note 
FROM county_parish
;
/* Result:
 county_parish_id | country | state_province | county_parish | county_parish_std | note 
------------------+---------+----------------+---------------+-------------------+------
(0 rows)
*/

--
-- Fix the affected records
--

-- 'Regional District of' prefix
UPDATE county_parish
SET changed=1,
county_parish_std=
regexp_replace(county_parish, 'Regional District of ', '', 'i')
WHERE county_parish ILIKE 'Regional District of %'
;

-- ' Regional District' suffix
UPDATE county_parish
SET changed=1,
county_parish_std=
regexp_replace(county_parish, ' Regional District', '', 'i')
WHERE county_parish ILIKE '% Regional District'
;

--
-- Validate changes
--

-- Using 'changed' flag
SELECT county_parish, county_parish_std
FROM county_parish
WHERE changed=1
;
/* 27 rows changed as expected */

-- Using EXCEPT method
SELECT
	county_parish, 
	county_parish_std, 
	changed,
	'county_parish' AS "table",
	'not in county_parish_bak' AS note 
FROM county_parish 
EXCEPT 
SELECT 
	county_parish, 
	county_parish_std, 
	changed,
	'county_parish' AS "table",
	'not in county_parish_bak' AS note 
FROM county_parish_bak
UNION
SELECT 
	county_parish, 
	county_parish_std, 
	changed,
	'county_parish_bak' AS "table",
	'not in county_parish' AS note 
FROM county_parish_bak 
EXCEPT 
SELECT 
	county_parish, 
	county_parish_std, 
	changed,
	'county_parish_bak' AS "table",
	'not in county_parish' AS note 
FROM county_parish
ORDER BY county_parish, note
;
/* All changes as expected */

-- Clear cache for past results involving affected political divisions
DELETE FROM cache
WHERE county_parish_verbatim ilike '%Regional District%'
;

--
-- DROP backup table
--

DROP TABLE county_parish_bak;

