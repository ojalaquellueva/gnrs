<?php
// alters staging tables, adds field holding plain ascii version of name

// Alter std staging table
echo "Altering staging tables...";
$msg_error = "failed to alter `$tbl_std_staging`!\r\n";
$index_name="$tbl_std_index_prefix"."$asciiNameFld"."_ndx";
$sql = "
	ALTER TABLE `$tbl_std_staging`
	ADD COLUMN `$asciiNameFld` VARCHAR(100) DEFAULT NULL,
	ADD INDEX `$index_name`(`$asciiNameFld`)
	;
	";
if (sql_execute($sql,$die_on_fail,$echo_on,"",$msg_error));

// Alter synonym staging table
$msg_error = "failed to alter `$tbl_syn_staging`!\r\n";
$index_name="$tbl_syn_index_prefix"."$asciiNameFld"."_ndx";
$sql = "
	ALTER TABLE `$tbl_syn_staging`
	ADD COLUMN `$asciiNameFld` VARCHAR(100) DEFAULT NULL,
	ADD INDEX `$index_name`(`$asciiNameFld`)
	;
	";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));


?>
