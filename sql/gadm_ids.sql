-- ------------------------------------------------------------
-- Populates gadm ids in user data
-- ------------------------------------------------------------

-- country
UPDATE user_data a
SET 
gid_0=b.gid_0
FROM country b
WHERE job=:'job'
AND a.country_id=b.country_id
;

-- state_province
UPDATE user_data a
SET 
gid_1=b.gid_1
FROM state_province b
WHERE job=:'job'
AND a.state_province_id=b.state_province_id
;

-- county_parish
UPDATE user_data a
SET 
gid_2=b.gid_2
FROM county_parish b
WHERE job=:'job'
AND a.county_parish_id=b.county_parish_id
;
