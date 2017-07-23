<?php
// Everything you need to set is here and in dbconfig.inc

// includes
include "../db_config.inc";	// connection info and name of database
include "../../functions.inc";
include "../../sql_functions.inc";

$timer_on="../timer_on.inc";
$timer_off_echo="../timer_off_echo.inc";

// Error-reporting and echo behaviour at runtime
$echo_on = true;
$die_on_fail = true;
$msg_success = "done\r\n";

// table names etc.
$tblgeo="newWorldCities";
$poldiv="country";
$tbl_poldiv="countryScrubbed";
$poldivVerbatim="countryVerbatim";

// confirmation message
$confmsg = "\r\nValidate $poldiv names from table $tblgeo? (Y=yes, N=no):";

// create table scripts names
$drop_sql = "drop_tables.sql";
$create_sql = "create_tables.sql";

;

?>
