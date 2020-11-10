-- ----------------------------------------------------------
-- Load raw data to table user_data
-- This step is source-specific
-- ----------------------------------------------------------

-- Insert unique values, omitting complete nulls
-- TRUNCATE user_data;
INSERT INTO user_data (
job,
user_id,
country_verbatim,
state_province_verbatim,
county_parish_verbatim
)
SELECT 
job,
user_id,
country,
state_province,
county_parish
FROM user_data_raw
WHERE job=:'job'
;

-- Detect poldiv submitted
UPDATE user_data
SET poldiv_submitted=NULL
WHERE job=:'job'
;
UPDATE user_data
SET poldiv_submitted='country'
WHERE job=:'job'
AND country_verbatim IS NOT NULL AND TRIM(country_verbatim)<>''
;
UPDATE user_data
SET poldiv_submitted='state_province'
WHERE job=:'job'
AND state_province_verbatim IS NOT NULL AND TRIM(state_province_verbatim)<>''
;
UPDATE user_data
SET poldiv_submitted='county_parish'
WHERE job=:'job'
AND county_parish_verbatim IS NOT NULL AND TRIM(county_parish_verbatim)<>''
;

-- Flag unresolvable poldivs with corrupted hierarchies
UPDATE user_data
SET poldiv_submitted='unresolvable'
WHERE job=:'job'
AND (
(state_province_verbatim<>'' AND country_verbatim='')
OR 
(county_parish<>'' AND (state_province_verbatim='' OR country_verbatim=''))
)
;

-- Construct text FK column
UPDATE user_data
SET poldiv_full=CONCAT_WS('@',
coalesce(trim(country_verbatim),''), 
coalesce(trim(state_province_verbatim),''), 
coalesce(trim(county_parish_verbatim),'')
)
WHERE job=:'job'
;