-- ----------------------------------------------------------
-- Import raw user data to table user_data_raw
--
-- Requires parameters:
--	$raw_data_tbl_temp --> :raw_data_tbl_temp (job-specific temp table)
--	$infile --> :infile
-- ----------------------------------------------------------

-- Create job-specific raw data table
DROP TABLE IF EXISTS :"raw_data_tbl_temp";
CREATE TABLE :"raw_data_tbl_temp" (
user_id text DEFAULT NULL,
country text DEFAULT NULL,
state_province text DEFAULT NULL,
county_parish text DEFAULT NULL
)
;

-- Import raw data
\COPY user_data_raw FROM :'infile' DELIMITER ',' CSV NULL AS 'NA' HEADER;

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
FROM :"raw_data_temp"
;

-- Drop job-specific raw data table
DROP TABLE IF EXISTS :"raw_data_tbl_temp";
