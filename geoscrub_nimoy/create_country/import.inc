<?php
// import text files into staging tables
echo "Importing text files to staging tables...";
foreach ($tbls as $tbl) {
	// Import csv file to table
	$file=$tbl.$ext;
	$tbl_staging=$tbl.$tbl_staging_suffix;
	$msg_error = "Failed to import text file";
	$sql = "LOAD DATA $local INFILE '$file' 
		INTO TABLE $tbl_staging 
		$fields_terminated_by 
		$optionally_enclosed_by 
		$lines_terminated_by 
		$ignore_lines;
		";
	if (sql_execute($sql,$die_on_fail,$echo_on,"",$msg_error));

	///// Delete duplicate rows, if any
	$tmptbl=$tbl."_temp";

	// Standardize NULLS
	if (!(empty_string_to_null($tbl))) die("Error, failed to convert empty strings to NULL\r\n.");
}
echo "done\r\n";

?>
