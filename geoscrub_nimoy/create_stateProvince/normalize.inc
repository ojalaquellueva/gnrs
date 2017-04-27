<?php
// Normalizes and loads data from staging tables into target tables

// Load distinct plain-ascii names & unique codes into standard names table
echo "Populating `$tbl_std`...";
$msg_error = "Failed!\r\n";
$sql = "
	INSERT INTO `$tbl_std` (
		countryID,
		stateProvinceNameStd,
		stateProvinceUniqueCode
	)
	SELECT DISTINCT
		c.countryID,
		s.$asciiNameFld
		s.stateProvinceUniqueCode
	FROM `$tbl_std_staging` s INNER JOIN country c
	ON s.countryIsoCode=c.isoCode
		;
	";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

// Update codes values
echo "Updating codes in `$tbl_std`...";
$msg_error = "Failed!\r\n";
$sql = "
	UPDATE `$tbl_std` a INNER JOIN (
		SELECT DISTINCT c.countryID, c.isoCode, b.$asciiNameFld, b.stateProvinceCode
		FROM country c INNER JOIN `$tbl_std_staging` b
		ON c.isoCode=b.countryIsoCode
	) AS g
	ON
       		a.countryID=g.countryID AND a.stateProvinceNameStd=g.$asciiNameFld
	SET
		a.stateProvinceCode=g.stateProvinceCode,
		a.HASC_1=CONCAT_WS('.',g.isoCode,g.stateProvinceCode)
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

// Load distinct original names from synonym staging table into temporary synonym table
// Assumes staging tables linked via PK-FK
echo "Populating `$tbl_syn_temp`...";
$msg_error = "Failed to add original names from $tbl_syn_staging!\r\n";
$sql = "
	INSERT INTO `$tbl_syn_temp` (
		stateProvinceID,
		stateProvinceName
	)
	SELECT DISTINCT
		a.stateProvinceID,
		c.stateProvinceName
		FROM (
			SELECT DISTINCT a.stateProvinceID,a.stateProvinceNameStd, c.isoCode
			FROM `$tbl_std` a INNER JOIN country c
			ON a.countryID=c.countryID
			) AS a
			INNER JOIN `$tbl_std_staging` b INNER JOIN `$tbl_syn_staging` c
		ON a.isoCode=b.countryIsoCode AND a.stateProvinceNameStd=b.$asciiNameFld AND b.stateProvinceID=c.stateProvinceID
	";
if (sql_execute($sql,$die_on_fail,$echo_on,"",$msg_error));

// Load distinct plain ascii names from synonym staging table into temporary synonym table
// Assumes staging tables linked via PK-FK
$msg_error = "Failed to add plain ascii names from $tbl_syn_staging!\r\n";
$sql = "
	INSERT INTO `$tbl_syn_temp` (
		stateProvinceID,
		stateProvinceName
	)
	SELECT DISTINCT
		a.stateProvinceID,
		c.$asciiNameFld
		FROM (
			SELECT DISTINCT a.stateProvinceID,a.stateProvinceNameStd, c.isoCode
			FROM `$tbl_std` a INNER JOIN country c
			ON a.countryID=c.countryID
			) AS a
			INNER JOIN `$tbl_std_staging` b INNER JOIN `$tbl_syn_staging` c
		ON a.isoCode=b.countryIsoCode AND a.stateProvinceNameStd=b.$asciiNameFld AND b.stateProvinceID=c.stateProvinceID
	";
if (sql_execute($sql,$die_on_fail,$echo_on,"",$msg_error));

// Load distinct original names 
// from standard staging table into temporary synonym tablele
$msg_error = "Failed to add original names from $tbl_std_staging!\r\n";
$sql = "
	INSERT INTO `$tbl_syn_temp` (
		stateProvinceID,
		stateProvinceName
	)
	SELECT DISTINCT
		a.stateProvinceID,
		b.$tbl_std_staging_poldiv
		FROM (
			SELECT DISTINCT a.stateProvinceID,a.stateProvinceNameStd, c.isoCode
			FROM `$tbl_std` a INNER JOIN country c
			ON a.countryID=c.countryID
			) AS a
			INNER JOIN `$tbl_std_staging` b 
		ON a.isoCode=b.countryIsoCode AND a.stateProvinceNameStd=b.$asciiNameFld
	";
if (sql_execute($sql,$die_on_fail,$echo_on,"",$msg_error));

// Load distinct plain ascii names 
// from standard staging table into temporary synonym tablele
$msg_error = "Failed to add plain ascii names from $tbl_std_staging!\r\n";
$sql = "
	INSERT INTO `$tbl_syn_temp` (
		stateProvinceID,
		stateProvinceName
	)
	SELECT DISTINCT
		a.stateProvinceID,
		b.$asciiNameFld
		FROM (
			SELECT DISTINCT a.stateProvinceID,a.stateProvinceNameStd, c.isoCode
			FROM `$tbl_std` a INNER JOIN country c
			ON a.countryID=c.countryID
			) AS a
			INNER JOIN `$tbl_std_staging` b
		ON a.isoCode=b.countryIsoCode AND a.stateProvinceNameStd=b.$asciiNameFld
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
