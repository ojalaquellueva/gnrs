/*
Fix incorrect gid_0 for South Sudan. Should be 'SSD', same as the iso_alpha3 code, not 'SDS'
*/

\c gnrs_2_2

UPDATE country
SET gid_0='SSD'
WHERE gid_0='SDS'
;