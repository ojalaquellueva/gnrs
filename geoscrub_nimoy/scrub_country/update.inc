<?php
// Updates scrubbed names to geoscrub table

// Insert unique values from geoscrub table in validation table
echo "Updating scrubbed names to table `$tblgeo`...";
$msg_error = "failed!";
$sql = "
	UPDATE $tblgeo g INNER JOIN $tbl_poldiv t
	ON g.$poldivVerbatim=t.$poldivVerbatim
	SET
	g.countryID=t.countryID
	;
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error))



?>
