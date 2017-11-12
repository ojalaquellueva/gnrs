<?php

// Insert unique values from geoscrub table in validation table
echo "Inserting unique $poldiv names into `$tblPoldivScrubbed`...";
$msg_error = "failed!";
$sql = "INSERT INTO $tblPoldivScrubbed (
	$poldivVerbatim,
	$poldivParentID
	) 
	SELECT DISTINCT
	g.$poldivVerbatim,
	g.$poldivParentID
	FROM
	$tblgeo g
	WHERE
	(g.$poldivVerbatim IS NOT NULL and TRIM(g.$poldivVerbatim)<>'') 
	AND g.$poldivParentID IS NOT NULL
	;
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));



?>
