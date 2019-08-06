--
-- Add new results to cache
-- 

-- JOIN on FK
INSERT INTO cache (
poldiv_full,
country_verbatim,
state_province_verbatim,
county_parish_verbatim,
country,
state_province,
county_parish,
country_id,
state_province_id,
county_parish_id,
country_iso,
state_province_iso,
county_parish_iso,
match_method_country,
match_method_state_province,
match_method_county_parish,
match_score_country,
match_score_state_province,
match_score_county_parish,
poldiv_submitted,
poldiv_matched,
match_status
)
SELECT  
a.poldiv_full,
a.country_verbatim,
a.state_province_verbatim,
a.county_parish_verbatim,
a.country,
a.state_province,
a.county_parish,
a.country_id,
a.state_province_id,
a.county_parish_id,
a.country_iso,
a.state_province_iso,
a.county_parish_iso,
a.match_method_country,
a.match_method_state_province,
a.match_method_county_parish,
a.match_score_country,
a.match_score_state_province,
a.match_score_county_parish,
a.poldiv_submitted,
a.poldiv_matched,
a.match_status
FROM (SELECT * FROM user_data WHERE job=:'job') a LEFT JOIN cache b 
ON a.poldiv_full=b.poldiv_full
WHERE b.poldiv_full IS NULL
;