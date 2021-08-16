-- ------------------------------------------------------------
-- Detect countries-as-states and shift verbatim
-- state and county up one level, saving the original country,
-- state and county strings in columns country_verbatim_orig,
-- state_province_orig and county_parish_orig so they can be
-- restored later
-- ------------------------------------------------------------




-- UNDER CONSTRUCTION ---


UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='exact standard name'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim=b.country
;

