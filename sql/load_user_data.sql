-- ----------------------------------------------------------
-- Load raw data to table user_data
--
-- Parameters:
--	:'job' - ID of current job
-- ----------------------------------------------------------

INSERT INTO user_data (
job,
user_id,
country_verbatim,
state_province_verbatim,
county_parish_verbatim
)
SELECT 
job,
user_id,
country,
state_province,
county_parish
FROM user_data_raw
WHERE job=:'job'
;

-- Construct text FK column poldiv_full
UPDATE user_data
SET poldiv_full=CONCAT_WS('@',
coalesce(trim(country_verbatim),''), 
coalesce(trim(state_province_verbatim),''), 
coalesce(trim(county_parish_verbatim),'')
)
WHERE job=:'job'
;

