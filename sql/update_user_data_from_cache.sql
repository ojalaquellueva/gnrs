-- ----------------------------------------------------------
-- Load raw data to table user_data
--
-- Parameters:
--	:'job' - ID of current job
-- ----------------------------------------------------------

UPDATE user_data u
SET
country=c.country,
state_province=c.state_province,
county_parish=c.county_parish,
country_id=c.country_id,
state_province_id=c.state_province_id,
county_parish_id=c.county_parish_id,
country_iso=c.country_iso,
state_province_iso=c.state_province_iso,
county_parish_iso=c.county_parish_iso,
geonameid=c.geonameid,
gid_0=c.gid_0,
gid_1=c.gid_1,
gid_2=c.gid_2,
match_method_country=c.match_method_country,
match_method_state_province=c.match_method_state_province,
match_method_county_parish=c.match_method_county_parish,
match_score_country=c.match_score_country,
match_score_state_province=c.match_score_state_province,
match_score_county_parish=c.match_score_county_parish,
overall_score=c.overall_score,
poldiv_submitted=c.poldiv_submitted,
poldiv_matched=c.poldiv_matched,
match_status=c.match_status
FROM cache c
WHERE u.job=:'job'
AND c.poldiv_full=u.poldiv_full
;