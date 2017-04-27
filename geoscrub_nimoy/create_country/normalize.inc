<?php
// Normalizes and loads data from staging tables into target tables

// Load distinct values into standard names table
echo "Populating `$tbl_std`...";
$msg_error = "Failed!\r\n";
$sql = "
	INSERT INTO `$tbl_std` (
		isoCode,
		countryCode3Char,
		countryNameStd
	)
	SELECT DISTINCT
		isoCode,
		countryCode3Char,
		countryNameStd
	FROM `$tbl_std_staging`;
	";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

// Load distinct values into synonym table
// Indexing assumes each name in synonym staging table has a
// valid isocode also appearing in standard names table
echo "Populating `$tbl_syn`...";
$msg_error = "Failed!\r\n";
$sql = "
	INSERT INTO `$tbl_syn` (
		countryID,
		countryName
	)
	SELECT DISTINCT
		a.countryID,
		c.countryName
	FROM `$tbl_std` a INNER JOIN `$tbl_std_staging` b INNER JOIN `$tbl_syn_staging` c
	ON a.countryNameStd=b.countryNameStd AND b.isoCode=c.isoCode
	";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

// Load distinct values into languages table
echo "Populating `$tbl_lang`...";
$msg_error = "Failed!\r\n";
$sql = "
	INSERT INTO `$tbl_lang` (
		langCode
	)
	SELECT DISTINCT
		langCode
	FROM `$tbl_syn_staging` 
	";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

// Link languages to names in synonym table
echo "Linking `$tbl_lang` to `$tbl_syn`...";
$msg_error = "Failed!\r\n";
$sql = "
	INSERT INTO `$tbl_lang_syn` (
		langCode,
		countryNameID
	)
	SELECT DISTINCT
		c.langCode,
		a.countryNameID
	FROM `$tbl_syn` a INNER JOIN `$tbl_syn_staging` b INNER JOIN `$tbl_lang` c
	ON a.countryName=b.countryName AND b.langCode=c.langCode
	";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

?>
