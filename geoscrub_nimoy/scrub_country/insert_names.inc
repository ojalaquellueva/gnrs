<?php

// Insert unique values from geoscrub table in validation table
echo "Inserting unique $poldiv names into `$tbl_poldiv`...";
$msg_error = "failed!";
$sql = "INSERT INTO $tbl_poldiv (
	$poldivVerbatim
	) 
	SELECT DISTINCT
	g.$poldivVerbatim
	FROM
	$tblgeo g
	WHERE
	g.$poldivVerbatim IS NOT NULL and TRIM(g.$poldivVerbatim)<>''
	;
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));



?>
