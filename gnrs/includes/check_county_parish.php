<?php

echo "Checking county_parish:\r\n";

echo "  Exact match to standard ascii name...";
$sql="
UPDATE user_data a
SET county_parish=b.county_parish_ascii,
county_parish_geonameid=b.county_parish_id,
match_method_county_parish='Exact match to plain ascii'
FROM county_parish b
WHERE a.country=b.country
AND a.state_province=b.state_province_ascii
AND a.county_parish_verbatim=b.county_parish
AND a.county_parish IS NULL
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to preferred name...";
$sql="
UPDATE user_data a
SET county_parish=b.county_parish_ascii,
county_parish_geonameid=b.county_parish_id,
match_method_county_parish='Exact match preferred name'
FROM county_parish b
WHERE a.country=b.country
AND a.state_province=b.state_province_ascii
AND a.county_parish_verbatim=b.county_parish
AND a.county_parish IS NULL
AND b.state_province_ascii<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;


echo "  Exact match to iso codes...";
$sql="
UPDATE user_data a
SET county_parish=b.county_parish_ascii,
county_parish_geonameid=b.county_parish_id,
match_method_county_parish='Exact match iso'
FROM county_parish b
WHERE a.country=b.country
AND a.state_province=b.state_province_ascii
AND a.county_parish_verbatim=b.county_parish_code
AND a.county_parish IS NULL
AND b.county_parish_code<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to full iso codes...";
$sql="
UPDATE user_data a
SET county_parish=b.county_parish_ascii,
county_parish_geonameid=b.county_parish_id,
match_method_county_parish='Exact match full iso'
FROM county_parish b
WHERE a.country=b.country
AND a.state_province=b.state_province_ascii
AND a.county_parish_verbatim=b.county_parish_code_full
AND a.county_parish IS NULL
AND b.county_parish_code_full<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to hasc_2 codes...";
$sql="
UPDATE user_data a
SET county_parish=b.county_parish_ascii,
county_parish_geonameid=b.county_parish_id,
match_method_county_parish='Exact match hasc_2'
FROM county_parish b
WHERE a.country=b.country
AND a.state_province=b.state_province_ascii
AND a.county_parish_verbatim=b.hasc_2
AND a.county_parish IS NULL
AND b.hasc_2<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to full hasc_2 codes...";
$sql="
UPDATE user_data a
SET county_parish=b.county_parish_ascii,
county_parish_geonameid=b.county_parish_id,
match_method_county_parish='Exact match full hasc_2'
FROM county_parish b
WHERE a.country=b.country
AND a.state_province=b.state_province_ascii
AND a.county_parish_verbatim=b.hasc_2_full
AND a.county_parish IS NULL
AND b.hasc_2_full<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;



echo "  Exact match to alternate names...";
$sql="
UPDATE user_data a
SET county_parish=c.county_parish_ascii,
county_parish_geonameid=b.county_parish_id,
match_method_county_parish='Exact match alternate name'
FROM county_parish_name b JOIN county_parish c
ON b.county_parish_id=c.county_parish_id
WHERE a.country=c.country
AND a.state_province=c.state_province_ascii
AND a.county_parish_verbatim=b.county_parish_name
AND a.county_parish IS NULL
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

?>