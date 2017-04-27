<?php
// Normalizes and loads data from staging tables into target tables

// Load distinct plain-ascii names into standard names table
echo "\r\npoldivParent=$poldivParent";
echo "\r\npoldivParentUniqueCode=$poldivParentUniqueCode";

echo "Populating `$tbl_std`...";
$msg_error = "Failed!\r\n";
$sql = "
	INSERT INTO `$tbl_std` (
		$poldivParentID,
		$tbl_std_staging_poldiv,
		$poldivUniqueCode

	)
	SELECT DISTINCT
		p.$poldivParentID,
		s.$asciiNameFld,
		s.$poldivUniqueCode
	FROM `$tbl_std_staging` s INNER JOIN $tblPoldivParent p
	ON s.$poldivParentUniqueCode=p.$poldivParentUniqueCode
		;
	";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

// Update codes values
echo "Updating codes in `$tbl_std`...";
$msg_error = "Failed!\r\n";
$sql = "
	UPDATE `$tbl_std` a INNER JOIN $tbl_std_staging s
	ON a.$poldivUniqueCode=s.$poldivUniqueCode
	SET
		a.$poldivTypeFld=s.$poldivTypeFld,
		a.$poldivHascCode=s.$poldivHascCode
		;
	";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

// Create temporary synonym table
$tbl_syn_temp=$tbl_syn."_temp";
echo "Creating temporary table `$tbl_syn_temp`...";
// Remove previous temporary table
$msg_error = "Failed to drop previous `$tbl_syn_temp`!\r\n";
$sql = "DROP TABLE IF EXISTS `$tbl_syn_temp`;";
if (sql_execute($sql,$die_on_fail,$echo_on,"",$msg_error));
// create new table
$msg_error = "Failed!\r\n";
$sql = "CREATE TABLE `$tbl_syn_temp` LIKE `$tbl_syn`;";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

// Load distinct original names 
// from synonym staging table into temporary synonym table
// Assumes staging tables linked via PK-FK
echo "Populating `$tbl_syn_temp`...";
$msg_error = "Failed to add original names from $tbl_syn_staging!\r\n";
$sql = "
	INSERT INTO `$tbl_syn_temp` (
		$tbl_std_pk,
		$tbl_syn_staging_poldiv
	)
	SELECT DISTINCT
		a.$tbl_std_pk,
		c.$tbl_syn_staging_poldiv
		FROM `$tbl_std` AS a INNER JOIN `$tbl_std_staging` b INNER JOIN `$tbl_syn_staging` c
		ON a.$poldivUniqueCode=b.$poldivUniqueCode AND b.$tbl_std_pk=c.$tbl_std_pk
	";
if (sql_execute($sql,$die_on_fail,$echo_on,"",$msg_error));

// Load distinct plain ascii names 
// from synonym staging table into temporary synonym table
// Assumes staging tables linked via PK-FK
$msg_error = "Failed to add plain ascii names from $tbl_syn_staging!\r\n";
$sql = "
	INSERT INTO `$tbl_syn_temp` (
		$tbl_std_pk,
		$tbl_syn_staging_poldiv
	)
	SELECT DISTINCT
		a.$tbl_std_pk,
		c.$asciiNameFld
		FROM `$tbl_std` AS a INNER JOIN `$tbl_std_staging` b INNER JOIN `$tbl_syn_staging` c
		ON a.$poldivUniqueCode=b.$poldivUniqueCode AND b.$tbl_std_pk=c.$tbl_std_pk
	";
if (sql_execute($sql,$die_on_fail,$echo_on,"",$msg_error));

// Load distinct original names 
// from standard staging table into temporary synonym tablele
$msg_error = "Failed to add original names from $tbl_std_staging!\r\n";
$sql = "
	INSERT INTO `$tbl_syn_temp` (
		$tbl_std_pk,
		$tbl_syn_staging_poldiv
	)
	SELECT DISTINCT
		a.$tbl_std_pk,
		b.$tbl_std_staging_poldiv
		FROM `$tbl_std` AS a INNER JOIN `$tbl_std_staging` b
		ON a.$poldivUniqueCode=b.$poldivUniqueCode
	";
if (sql_execute($sql,$die_on_fail,$echo_on,"",$msg_error));

// Load distinct plain ascii names 
// from standard staging table into temporary synonym table
$msg_error = "Failed to add plain ascii names from $tbl_std_staging!\r\n";
$sql = "
	INSERT INTO `$tbl_syn_temp` (
		$tbl_std_pk,
		$tbl_syn_staging_poldiv
	)
	SELECT DISTINCT
		a.$tbl_std_pk,
		b.$asciiNameFld
		FROM `$tbl_std` AS a INNER JOIN `$tbl_std_staging` b
		ON a.$poldivUniqueCode=b.$poldivUniqueCode
	";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

// Insert distinct values into permanent table
echo "Loading distinct names to table `$tbl_syn`...";
$msg_error = "Failed!\r\n";
$sql = "INSERT INTO `$tbl_syn` SELECT DISTINCT * FROM `$tbl_syn_temp`;";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

// Remove temporary table
echo "Dropping table `$tbl_syn_temp`...";
$msg_error = "error!\r\n";
$sql = "DROP TABLE IF EXISTS `$tbl_syn_temp`;";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

?>
