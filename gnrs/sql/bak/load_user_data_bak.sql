-- ----------------------------------------------------------
-- Load raw data to table user_data
-- This step is source-specific
-- ----------------------------------------------------------

-- Insert unique values, omitting complete nulls
INSERT INTO user_data (
poldiv_full,
country_verbatim,
state_province_verbatim,
county_parish_verbatim,
poldiv_submitted
)
SELECT DISTINCT
poldiv_full,
country,
state_province,
county_parish,
CASE
WHEN state_province='' THEN 'country'
WHEN county_parish='' THEN 'state_province'
ELSE 'county_parish'
END
FROM :tbl_raw
WHERE poldiv_full<>'@@'
;

-- Flag unresolvable poldivs with corrupted hierarchies
UPDATE user_data
SET poldiv_submitted='unresolvable'
WHERE 
(state_province_verbatim<>'' AND country_verbatim='')
OR 
(county_parish<>'' AND (state_province_verbatim='' OR country_verbatim=''))
;