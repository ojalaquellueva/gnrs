-- ----------------------------------------------------------
-- Load raw data to table user_data
-- This step is source-specific
-- ----------------------------------------------------------

-- Insert unique values, omitting complete nulls
TRUNCATE user_data;
INSERT INTO user_data (
user_id,
country_verbatim,
state_province_verbatim,
county_parish_verbatim
)
SELECT DISTINCT
user_id,
country,
state_province,
county_parish
FROM user_data_raw
;

-- Detect poldiv submitted
UPDATE user_data
SET poldiv_submitted=
CASE
WHEN state_province='' THEN 'country'
WHEN county_parish='' THEN 'state_province'
ELSE 'county_parish'
END
;

-- Flag unresolvable poldivs with corrupted hierarchies
UPDATE user_data
SET poldiv_submitted='unresolvable'
WHERE 
(state_province_verbatim<>'' AND country_verbatim='')
OR 
(county_parish<>'' AND (state_province_verbatim='' OR country_verbatim=''))
;

-- Construct text FK column
UPDATE user_data
SET poldiv_full=CONCAT_WS('@',
trim(country_verbatim), 
trim(state_province_verbatim), 
trim(county_parish_verbatim) 
)
;