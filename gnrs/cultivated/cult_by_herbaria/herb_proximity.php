<?php
// Set isCultivated=1 in table geoscrub for any records within
// set radius of a herbarium
// Herbaria often associated with botanical gardens, therefore source
// of cultivated specimens

include "params.inc";	// everything you need to set is here and dbconfig.inc

if (confirm($confmsg)) {
	echo "\r\nBegin operation\r\n\r\n";
	include $timer_on;
}

// connect to database
if (!($dbh=db_connect($HOST,$USER,$PWD,$DB_GEO,$echo_on))) die();

include_once "flag_by_herbaria.inc";	// insert unique names from geoscrub table

mysql_close($dbh);
include $timer_off_echo;
echo "Operation completed\r\n\r\n";

?>
