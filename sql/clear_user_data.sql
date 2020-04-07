-- ----------------------------------------------------------
-- Clear user data for this job
-- 
-- Require parameters: 
--	$job --> :job

-- ----------------------------------------------------------

DELETE FROM user_data
WHERE job=:'job'
;
DELETE FROM user_data_raw
WHERE job=:'job'
;