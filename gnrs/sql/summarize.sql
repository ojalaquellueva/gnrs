-- Mark political division matched
UPDATE user_data
SET poldiv_matched='country'
WHERE country IS NOT NULL
AND state_province IS NULL
AND county_parish IS NULL
;

UPDATE user_data
SET poldiv_matched='state_province'
WHERE country IS NOT NULL
AND state_province IS NOT NULL
AND county_parish IS NULL
;

UPDATE user_data
SET poldiv_matched='county_parish'
WHERE country IS NOT NULL
AND state_province IS NOT NULL
AND county_parish IS NOT NULL
;

-- Summarize overall match success
UPDATE user_data
SET match_status='full match'
WHERE poldiv_matched=poldiv_submitted
;

UPDATE user_data
SET match_status='partial match'
WHERE poldiv_matched<>poldiv_submitted
;

UPDATE user_data
SET match_status='no match'
WHERE poldiv_submitted IS NOT NULL
AND poldiv_matched IS NULL
;
