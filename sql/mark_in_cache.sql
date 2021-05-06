-- -------------------------------------------------------------------
-- Mark submitted political divisions already in cache
-- -------------------------------------------------------------------

UPDATE user_data u 
SET is_in_cache=1
FROM cache c
WHERE u.job=:'job'
AND u.poldiv_full=c.poldiv_full
;
