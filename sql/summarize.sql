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

-- Index for faster updates
DROP INDEX IF EXISTS user_data_country_idx;
DROP INDEX IF EXISTS user_data_state_province_idx;
DROP INDEX IF EXISTS user_data_county_parish_idx;
DROP INDEX IF EXISTS user_data_poldiv_matched_idx;
DROP INDEX IF EXISTS user_data_poldiv_submitted_idx;

CREATE INDEX user_data_country_idx ON user_data (country);
CREATE INDEX user_data_state_province_idx ON user_data (state_province);
CREATE INDEX user_data_county_parish_idx ON user_data (county_parish);
CREATE INDEX user_data_poldiv_matched_idx ON user_data (poldiv_matched);
CREATE INDEX user_data_poldiv_submitted_idx ON user_data (poldiv_submitted);

-- Mark political division matched
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

-- Summarize overall match success
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
