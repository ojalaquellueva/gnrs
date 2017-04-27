<?php
// Converts all names to plain ascii equivalents
// Will result in some duplications, but this will be taken care of 
// during normalization

/////////// Standard name table ///////////

// Remove single quotes temporarily
echo "Removing single quotes (first table)...";
$msg_error="Failed!\r\n";
$sql="
	UPDATE $tbl_std_staging 
	SET 
	$tbl_std_staging_poldiv=REPLACE($tbl_std_staging_poldiv,\"'\",\"@@@\");
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// Loop through table
echo "Converting names to plain ascii...";
$query="
	SELECT DISTINCT $tbl_std_staging_poldiv
	FROM $tbl_std_staging
	WHERE $tbl_std_staging_poldiv IS NOT NULL;
";
$result=mysql_query($query);
$num_rows=mysql_numrows($result);

if ($num_rows>0) {
	while ($row=mysql_fetch_array($result, MYSQL_ASSOC)) {
		$poldiv_orig=$row{$tbl_std_staging_poldiv};
		$str=$poldiv_orig;
	
		// strip unnecessary punctuation
		$str=str_replace(chr(63),"",$str);  //  ?
		$str=str_replace(chr(34),"",$str);  //  "

		// Convert to plain ascii
		$pd_plainAscii=ext2ascii($str);
	
		$sql="UPDATE `$tbl_std_staging`
			SET $asciiNameFld='$pd_plainAscii' 
			WHERE $tbl_std_staging_poldiv='$poldiv_orig' 
			;
			";
		$msg_error="Failed to update $asciiNameFld for $tbl_std_staging_poldiv=$poldiv_orig!";
			if (sql_execute($sql,TRUE,$echo_on,'',$msg_error));

	}
}

echo $msg_success;

// Replace any single quotes
echo "Restoring single quotes...";
$msg_error="Failed!\r\n";
$sql="
	UPDATE $tbl_std_staging 
	SET 
	$tbl_std_staging_poldiv=REPLACE($tbl_std_staging_poldiv,\"@@@\",\"'\"),
	$asciiNameFld=REPLACE($asciiNameFld,\"@@@\",\"'\")
	;
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

/////////// Synonym table ///////////

// Remove single quotes temporarily
echo "Removing single quotes (second table)...";
$msg_error="Failed!\r\n";
$sql="
	UPDATE $tbl_syn_staging 
	SET 
	$tbl_syn_staging_poldiv=REPLACE($tbl_syn_staging_poldiv,\"'\",\"@@@\");
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// Loop through table
echo "Converting names to plain ascii...";
$query="
	SELECT DISTINCT $tbl_syn_staging_poldiv
	FROM $tbl_syn_staging
	WHERE $tbl_syn_staging_poldiv IS NOT NULL;
";
$result=mysql_query($query);
$num_rows=mysql_numrows($result);

if ($num_rows>0) {
	while ($row=mysql_fetch_array($result, MYSQL_ASSOC)) {
		$poldiv_orig=$row{$tbl_syn_staging_poldiv};
		$str=$poldiv_orig;
	
		// strip unnecessary punctuation
		$str=str_replace(chr(63),"",$str);  //  ?
		$str=str_replace(chr(34),"",$str);  //  "

		// Convert to plain ascii
		$pd_plainAscii=ext2ascii($str);
	
		$sql="UPDATE `$tbl_syn_staging`
			SET $asciiNameFld='$pd_plainAscii' 
			WHERE $tbl_syn_staging_poldiv='$poldiv_orig' 
			;
			";
		$msg_error="Failed to update $asciiNameFld for $tbl_syn_staging_poldiv=$poldiv_orig!";
			if (sql_execute($sql,TRUE,$echo_on,'',$msg_error));

	}
}

echo $msg_success;

// Replace any single quotes
echo "Restoring single quotes...";
$msg_error="Failed!\r\n";
$sql="
	UPDATE $tbl_syn_staging 
	SET 
	$tbl_syn_staging_poldiv=REPLACE($tbl_syn_staging_poldiv,\"@@@\",\"'\"),
	$asciiNameFld=REPLACE($asciiNameFld,\"@@@\",\"'\")
	;
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));


?>
