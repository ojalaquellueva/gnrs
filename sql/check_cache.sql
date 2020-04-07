--
-- Check for existing results in cache
-- 

-- Recreate FK & WHERE indexes
DROP INDEX IF EXISTS user_data_poldiv_full_idx;
DROP INDEX IF EXISTS cache_poldiv_full_idx;
CREATE INDEX user_data_poldiv_full_idx ON user_data (poldiv_full);
CREATE INDEX cache_poldiv_full_idx ON cache (poldiv_full);

-- JOIN on FK
UPDATE user_data a 
SET 
country_verbatim=b.country_verbatim,
state_province_verbatim=b.state_province_verbatim,
county_parish_verbatim=b.county_parish_verbatim,
country=b.country,
state_province=b.state_province,
county_parish=b.county_parish,
country_id=b.country_id,
state_province_id=b.state_province_id,
county_parish_id=b.county_parish_id,
match_method_country=b.match_method_country,
match_method_state_province=b.match_method_state_province,
match_method_county_parish=b.match_method_county_parish,
match_score_country=b.match_score_country,
match_score_state_province=b.match_score_state_province,
match_score_county_parish=b.match_score_county_parish,
poldiv_submitted=b.poldiv_submitted,
poldiv_matched=b.poldiv_matched,
match_status=b.match_status
FROM cache b
WHERE a.poldiv_full=b.poldiv_full
AND a.job=:'job'
;