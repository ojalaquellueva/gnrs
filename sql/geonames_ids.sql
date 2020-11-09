-- ------------------------------------------------------------
-- Populates geonames ids in user data
-- Keep geonameid of lowest political division matched
-- ------------------------------------------------------------

-- country
UPDATE user_data a
SET 
geonameid=b.country_id
FROM country b
WHERE job=:'job'
AND a.country_id=b.country_id
AND b.is_geoname=1
;

-- state_province
UPDATE user_data a
SET 
geonameid=b.state_province_id
FROM state_province b
WHERE job=:'job'
AND a.state_province_id=b.state_province_id
AND b.is_geoname=1
;

-- county_parish
UPDATE user_data a
SET 
geonameid=b.county_parish_id
FROM county_parish b
WHERE job=:'job'
AND a.county_parish_id=b.county_parish_id
AND b.is_geoname=1
;
