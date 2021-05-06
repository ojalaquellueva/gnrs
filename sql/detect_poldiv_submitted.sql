-- ----------------------------------------------------------
-- Detect political divisions submitted
-- 
-- Parameters:
--	:'job' - ID of current job
-- ----------------------------------------------------------

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

