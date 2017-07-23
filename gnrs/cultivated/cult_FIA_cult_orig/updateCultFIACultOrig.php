<?php

include "params.inc";	// everything you need to set is here and dbconfig.inc

if (confirm($confmsg)) {
	echo "\r\nBegin operation\r\n\r\n";
	include $timer_on;
}

// connect to database
if (!($dbh=db_connect($HOST,$USER,$PWD,$DB_GEO,$echo_on))) die();

// update isCultivated fields for FIA plots and transfer any
// original cultivated flags from specimens
include_once "update.inc";	

mysql_close($dbh);
include $timer_off_echo;
echo "Operation completed\r\n\r\n";

?>
