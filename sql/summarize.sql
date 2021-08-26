--
-- Detect lowest political division submitted
--

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

--
-- Detect lowest political division matched
--

-- Regular political divisions
UPDATE user_data
SET poldiv_matched='country'
WHERE job=:'job'
AND country IS NOT NULL
AND state_province IS NULL
AND county_parish IS NULL
;

UPDATE user_data
SET poldiv_matched='state_province'
WHERE job=:'job'
AND country IS NOT NULL
AND state_province IS NOT NULL
AND county_parish IS NULL
;

UPDATE user_data
SET poldiv_matched='county_parish'
WHERE job=:'job'
AND country IS NOT NULL
AND state_province IS NOT NULL
AND county_parish IS NOT NULL
;

-- State-as-country
UPDATE user_data
SET poldiv_matched='state-as-country'
WHERE job=:'job'
AND match_method_country LIKE '%state-as-country%'
;
-- The following are a subset of the preceding
UPDATE user_data
SET poldiv_matched='county-as-state'
WHERE job=:'job'
AND match_method_state_province LIKE '%county-as-state%'
;

-- Country-as-state
UPDATE user_data
SET poldiv_matched='country-as-state'
WHERE job=:'job'
AND match_method_state_province LIKE '%country-as-state%'
;
-- The following are a subset of the preceding
UPDATE user_data
SET poldiv_matched='state-as-county'
WHERE job=:'job'
AND match_method_county_parish LIKE '%state-as-county%'
;

--
-- Summarize overall match status
--

-- Regular political divisions
UPDATE user_data
SET match_status='full match'
WHERE job=:'job'
AND poldiv_matched=poldiv_submitted
;
UPDATE user_data
SET match_status='partial match'
WHERE job=:'job'
AND poldiv_matched<>poldiv_submitted
;
UPDATE user_data
SET match_status='no match'
WHERE job=:'job'
AND poldiv_submitted IS NOT NULL
AND poldiv_matched IS NULL
;

-- State-as-country
UPDATE user_data
SET match_status=
CASE
WHEN coalesce(county_parish_verbatim,'')='' THEN 'full match'
ELSE 'partial match'
END
WHERE job=:'job'
AND poldiv_matched='state-as-country'
;
-- county as state
UPDATE user_data
SET match_status= 'full match'
WHERE job=:'job'
AND poldiv_matched='county-as-state'
;

-- Country-as-state
UPDATE user_data
SET match_status=
CASE
WHEN coalesce(state_province_verbatim,'')='' THEN 'full match'
ELSE 'partial match'
END
WHERE job=:'job'
AND poldiv_matched='country-as-state'
;
-- State-as-county
UPDATE user_data
SET match_status='full match'
WHERE job=:'job'
AND poldiv_matched='state-as-county'
;
