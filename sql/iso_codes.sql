-- ------------------------------------------------------------
-- Populates ISO codes in user data
-- Extra step added by request
-- ------------------------------------------------------------

-- country
UPDATE user_data a
SET 
country_iso=b.iso
FROM country b
WHERE job=:'job'
AND a.country_id=b.country_id
;

-- state_province
UPDATE user_data a
SET 
state_province_iso=b.state_province_code
FROM state_province b
WHERE job=:'job'
AND a.state_province_id=b.state_province_id
;

-- county_parish
UPDATE user_data a
SET 
county_parish_iso=b.county_parish_code
FROM county_parish b
WHERE job=:'job'
AND a.county_parish_id=b.county_parish_id
;
