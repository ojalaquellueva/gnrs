-- ------------------------------------------------------------
--  Populate match scores
-- ------------------------------------------------------------

--
-- Calculate match scores for each political division
-- 

UPDATE user_data u
SET 
match_score_country=
similarity(state_province_verbatim,country)
WHERE u.job=:'job' 
AND match_score_country IS NULL 
AND coalesce(country_verbatim,'')<>''
AND country IS NOT NULL
AND match_method_country LIKE '%state-as-country%'
;
UPDATE user_data u
SET 
match_score_country=
CASE
WHEN coalesce(country,'')='' THEN 0
WHEN coalesce(country,'')<>'' THEN 1
END
WHERE u.job=:'job' 
AND match_score_country IS NULL AND coalesce(country_verbatim,'')<>''
;

UPDATE user_data u
SET 
match_score_state_province=
similarity(country_verbatim,state_province)
WHERE u.job=:'job' 
AND match_score_state_province IS NULL 
AND coalesce(country_verbatim,'')<>''
AND state_province IS NOT NULL
AND match_method_state_province LIKE '%country-as-state%'
;
UPDATE user_data u
SET 
match_score_state_province=
CASE
WHEN coalesce(state_province,'')='' THEN 0
WHEN coalesce(state_province,'')<>'' THEN 1
END
WHERE u.job=:'job' 
AND match_score_state_province IS NULL AND coalesce(state_province_verbatim,'')<>''
;

UPDATE user_data u
SET 
match_score_county_parish=
similarity(state_province_verbatim,county_parish)
WHERE u.job=:'job' 
AND match_score_county_parish IS NULL 
AND coalesce(state_province_verbatim,'')<>''
AND county_parish IS NOT NULL
AND match_method_county_parish LIKE '%state-as-county%'
;
UPDATE user_data u
SET 
match_score_county_parish=
CASE
WHEN coalesce(county_parish,'')='' THEN 0
WHEN coalesce(county_parish,'')<>'' THEN 1
END
WHERE u.job=:'job' 
AND match_score_county_parish IS NULL AND coalesce(county_parish_verbatim,'')<>''
;

-- 
-- Calculate overall score
--

UPDATE user_data u
SET 
overall_score=
CASE
WHEN match_score_state_province IS NULL AND match_score_county_parish IS NULL THEN match_score_country
WHEN match_score_state_province IS NOT NULL AND match_score_county_parish IS NULL THEN (match_score_country + match_score_state_province  ) / 2
WHEN match_score_state_province IS NOT NULL AND match_score_county_parish IS NOT NULL THEN (match_score_country + match_score_state_province + match_score_county_parish ) / 3
END
WHERE u.job=:'job' 
AND match_score_country IS NOT NULL
;


