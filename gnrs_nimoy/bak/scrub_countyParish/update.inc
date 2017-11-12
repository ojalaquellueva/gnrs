<?php
// Updates scrubbed names to geoscrub table

// Insert unique values from geoscrub table in validation table
echo "Updating scrubbed $poldiv names to table `$tblgeo`...";
$msg_error = "failed!";
$sql = "
	UPDATE $tblgeo g INNER JOIN $tblPoldivScrubbed t
	ON g.$poldivVerbatim=t.$poldivVerbatim
	AND g.$poldivParentID=t.$poldivParentID
	SET
	g.$poldivID=t.$poldivID
	;
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error))



?>
