-- ----------------------------------------------------------
-- Load raw data to generic raw data table from job-specific 
-- temp table, adding job #
--
-- Requires parameters:
--	$raw_data_tbl_temp --> :raw_data_tbl_temp (job-specific temp table)
--	$job --> :job
-- ----------------------------------------------------------

-- Delete existing records for this job, if any
DELETE FROM user_data_raw
WHERE job=:'job'
;

-- Insert records plus job# to main raw data table
INSERT INTO user_data_raw (
job,
user_id,
country,
state_province,
county_parish
)
SELECT 
:'job',
user_id,
country,
state_province,
county_parish
FROM :"raw_data_tbl_temp"
;

-- Drop job-specific raw data table
DROP TABLE IF EXISTS :"raw_data_tbl_temp";
