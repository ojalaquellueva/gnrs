-- --------------------------------------------------------------------
-- Purge existing cached results for current set of verbatim political
-- divisions
-- 
-- Parameters:
--	:job: ID of current job
-- --------------------------------------------------------------------

UPDATE cache c
SET match_status='delete'
FROM user_data u 
WHERE u.job=:'job'
AND u.poldiv_full=c.poldiv_full
;

-- Delete records from cache
DELETE FROM cache
WHERE match_status='delete'
;

