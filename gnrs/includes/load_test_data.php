<?php

/////////////////////////////////////////
// Call this script for testing
/////////////////////////////////////////

// Edit as needed
$test_data="
('United States','Arizona',NULL),
('United States','California',''),
('United States','Arizona','Pima'),
('United States','Arizona','junk'),
('Costa Rica',NULL,NULL),
('USA','Arizona','Yavapai'),
('U.S.A.','',''),
('Canada','BC','')
";



echo "Loading example data:\r\n";

echo "  Preparing table...";
$sql="
TRUNCATE user_data;
DROP INDEX IF EXISTS user_data_country_verbatim_idx;
DROP INDEX IF EXISTS user_data_state_province_verbatim_idx;
DROP INDEX IF EXISTS user_data_county_parish_verbatim_idx;
DROP INDEX IF EXISTS user_data_country_idx;
DROP INDEX IF EXISTS user_data_state_province_idx;
DROP INDEX IF EXISTS user_data_county_parish_idx;
DROP INDEX IF EXISTS user_data_country_geonameid_idx;
DROP INDEX IF EXISTS user_data_state_province_geonameid_idx;
DROP INDEX IF EXISTS user_data_county_parish_geonameid_idx;
DROP INDEX IF EXISTS user_data_match_method_country_idx;
DROP INDEX IF EXISTS user_data_match_method_state_province_idx;
DROP INDEX IF EXISTS user_data_match_method_county_parish_idx;
DROP INDEX IF EXISTS user_data_poldiv_submitted_idx;
DROP INDEX IF EXISTS user_data_poldiv_matched_idx;
DROP INDEX IF EXISTS user_data_user_id_idx;

";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Inserting records...";
$sql="
INSERT INTO user_data (
country_verbatim,
state_province_verbatim,
county_parish_verbatim
)
VALUES
$test_data
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Setting nulls to empty string...";
$sql="
UPDATE user_data 
SET country_verbatim=
CASE WHEN country_verbatim IS NULL THEN ''
ELSE country_verbatim
END,
state_province_verbatim=
CASE WHEN state_province_verbatim IS NULL THEN ''
ELSE state_province_verbatim
END,
county_parish_verbatim=
CASE WHEN county_parish_verbatim IS NULL THEN ''
ELSE county_parish_verbatim
END
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Indexing example data...";
$sql="
CREATE INDEX user_data_country_verbatim_idx ON user_data (country_verbatim);
CREATE INDEX user_data_state_province_verbatim_idx ON user_data (state_province_verbatim);
CREATE INDEX user_data_county_parish_verbatim_idx ON user_data (county_parish_verbatim);
CREATE INDEX user_data_country_idx ON user_data (country);
CREATE INDEX user_data_state_province_idx ON user_data (state_province);
CREATE INDEX user_data_county_parish_idx ON user_data (county_parish);
CREATE INDEX user_data_country_geonameid_idx ON user_data (country_geonameid);
CREATE INDEX user_data_state_province_geonameid_idx ON user_data (state_province_geonameid);
CREATE INDEX user_data_county_parish_geonameid_idx ON user_data (county_parish_geonameid);
CREATE INDEX user_data_match_method_country_idx ON user_data (match_method_country);
CREATE INDEX user_data_match_method_state_province_idx ON user_data (match_method_state_province);
CREATE INDEX user_data_match_method_county_parish_idx ON user_data (match_method_county_parish);
CREATE INDEX user_data_poldiv_submitted_idx ON user_data (poldiv_submitted);
CREATE INDEX user_data_poldiv_matched_idx ON user_data (poldiv_matched);
CREATE INDEX user_data_user_id_idx ON user_data (user_id);
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;


?>