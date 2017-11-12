<?php

echo "Checking country:\r\n";

echo "  Exact match to standard ascii name...";
$sql="
UPDATE user_data a
SET 
country=b.country,
country_geonameid=b.country_id,
match_method_country='Exact match to standard name'
FROM country b
WHERE a.country_verbatim=b.country
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to 2-letter iso codes...";
$sql="
UPDATE user_data a
SET country=b.country,
country_geonameid=b.country_id,
match_method_country='Exact match 2-letter iso'
FROM country b
WHERE a.country_verbatim=b.iso
AND a.country IS NULL
AND b.iso<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to 3-letter iso codes...";
$sql="
UPDATE user_data a
SET country=b.country,
country_geonameid=b.country_id,
match_method_country='Exact match 3-letter iso'
FROM country b
WHERE a.country_verbatim=b.iso_alpha3
AND a.country IS NULL
AND b.iso_alpha3<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to fips codes...";
$sql="
UPDATE user_data a
SET country=b.country,
country_geonameid=b.country_id,
match_method_country='Exact match fips'
FROM country b
WHERE a.country_verbatim=b.fips
AND a.country IS NULL
AND b.fips<>''
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;

echo "  Exact match to alternate names...";
$sql="
UPDATE user_data a
SET country=b.country_name_std,
country_geonameid=b.country_id,
match_method_country='Exact match alternate name'
FROM country_name b
WHERE a.country_verbatim=b.country_name
AND a.country IS NULL
;
";
if(!$results = pg_query($dbh, $sql)) die(pg_last_error($dbh));
echo $done;


?>