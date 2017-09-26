<?php

echo "Checking state_province:\r\n";

echo "  Exact match to standard ascii name...";
$sql="
UPDATE user_data a
SET 
state_province=b.state_province_std,
state_province_geonameid=b.state_province_id,
match_method_state_province='Exact match to standard name'
FROM state_province b
WHERE a.country=b.country
AND a.state_province_verbatim=b.state_province 
AND a.state_province IS NULL
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to plain ascii name...";
$sql="
UPDATE user_data a
SET 
state_province=b.state_province_std,
state_province_geonameid=b.state_province_id,
match_method_state_province='Exact match plain ascii'
FROM state_province b
WHERE a.country=b.country
AND a.state_province_verbatim=b.state_province_ascii 
AND a.state_province IS NULL
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to preferred name...";
$sql="
UPDATE user_data a
SET 
state_province=b.state_province_std,
state_province_geonameid=b.state_province_id,
match_method_state_province='Exact match preferred name'
FROM state_province b
WHERE a.country=b.country
AND a.state_province_verbatim=b.state_province 
AND a.state_province IS NULL
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to iso codes...";
$sql="
UPDATE user_data a
SET state_province=b.state_province_std,
state_province_geonameid=b.state_province_id,
match_method_state_province='Exact match iso'
FROM state_province b
WHERE a.country=b.country
AND a.state_province_verbatim=b.state_province_code
AND a.state_province IS NULL
AND b.state_province_code<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to full iso codes...";
$sql="
UPDATE user_data a
SET state_province=b.state_province_std,
state_province_geonameid=b.state_province_id,
match_method_state_province='Exact match full iso'
FROM state_province b
WHERE a.country=b.country
AND a.state_province_verbatim=b.state_province_code_full
AND a.state_province IS NULL
AND b.state_province_code_full<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to hasc codes...";
$sql="
UPDATE user_data a
SET state_province=b.state_province_std,
state_province_geonameid=b.state_province_id,
match_method_state_province='Exact match hasc'
FROM state_province b
WHERE a.country=b.country
AND a.state_province_verbatim=b.hasc
AND a.state_province IS NULL
AND b.hasc<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to full hasc codes...";
$sql="
UPDATE user_data a
SET state_province=b.state_province_std,
state_province_geonameid=b.state_province_id,
match_method_state_province='Exact match full hasc'
FROM state_province b
WHERE a.country=b.country
AND a.state_province_verbatim=b.hasc_full
AND a.state_province IS NULL
AND b.hasc_full<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;



echo "  Exact match to alternate names...";
$sql="
UPDATE user_data a
SET state_province=c.state_province_std,
state_province_geonameid=b.state_province_id,
match_method_state_province='Exact match alternate name'
FROM state_province_name b JOIN state_province c
ON b.state_province_id=c.state_province_id
WHERE a.country=c.country
AND a.state_province_verbatim=b.state_province_name
AND a.state_province IS NULL
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

?>