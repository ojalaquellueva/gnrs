-- Mark complete non-matches
UPDATE user_data
SET poldiv_matched='No match'
WHERE country IS NULL
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