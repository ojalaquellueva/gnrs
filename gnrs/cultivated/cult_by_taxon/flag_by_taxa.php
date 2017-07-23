<?php

include "params.inc";	// everything you need to set is here and dbconfig.inc

if (confirm($confmsg)) {
	echo "\r\nBegin operation\r\n\r\n";
	include $timer_on;
}

// connect to database
if (!($dbh=db_connect($HOST,$USER,$PWD,$DB_GEO,$echo_on))) die();

//include_once "flag_by_taxa.inc";	// insert unique names from geoscrub table
include_once "temp_occurID.inc";

mysql_close($dbh);
include $timer_off_echo;
echo "Operation completed\r\n\r\n";

?>
