<?php
// Flag coordinate with basic integrity error (NULL, zero, or out of range) 

echo "Flagging records with invalid coordinates...";

$msg_error = "failed to flag null coordinates!\r\n";
$coord_msg = "NULL coordinates";
$sql="
	UPDATE $DB_GEO.geoscrub
	SET isBadLatLong=1,
	badLatLongReason=IF(badLatLongReason IS NULL,$coord_ms,CONCAT('; ',$coord_ms))
	WHERE latitudeDecimalVerbatim IS NULL OR longitudeDecimalVerbatim IS NULL;
";
if (sql_execute($sql,$die_on_fail,$echo_on,'',$msg_error));

$msg_error = "failed to flag coordinates out of range!\r\n";
$coord_msg = "latitude out of range";
$sql="
	UPDATE $DB_GEO.geoscrub
	SET isBadLatLong=1,
	badLatLongReason=IF(badLatLongReason IS NULL,$coord_ms,CONCAT('; ',$coord_ms))
	WHERE latitudeDecimalVerbatim<=-90 OR latitudeDecimalVerbatim>=90;
";
if (sql_execute($sql,$die_on_fail,$echo_on,'',$msg_error));

$msg_error = "failed to flag coordinates out of range!\r\n";
$coord_msg = "longitude out of range";
$sql="
	UPDATE $DB_GEO.geoscrub
	SET isBadLatLong=1,
	badLatLongReason=IF(badLatLongReason IS NULL,$coord_ms,CONCAT('; ',$coord_ms))
	WHERE longitudeDecimalVerbatim<-180 OR longitudeDecimalVerbatim>180;
";
if (sql_execute($sql,$die_on_fail,$echo_on,'',$msg_error));

$msg_error = "failed to flag zero latitude!\r\n";
$coord_msg = "latitude exactly zero";
$sql="
	UPDATE $DB_GEO.geoscrub
	SET isBadLatLong=1,
	badLatLongReason=IF(badLatLongReason IS NULL,$coord_ms,CONCAT('; ',$coord_ms))
	WHERE latitudeDecimalVerbatim=0;
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));



?>
