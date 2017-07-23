<?php
// Everything you need to set is here and in dbconfig.inc

///////////////////////////////////////////
// Application parameters
///////////////////////////////////////////

// Minimum allowable distance to herbarium
// any observation < this distance is 
// flagged as cultivated
// Empirically 3 km works best
// Even if there is no botanical garden
// associated with this herbarium,
// specimens are almost always in urban
// areas and therefore suspect
// >3 km gives too many false positives
$minDistKm = 3;

// Set to true to remove temporary table
// of IDs and distance to nearest herbarium.
// Otherwise false.
// You may want to keep this table if you need to examine
// properties of observations as a function of distance
// to nearest herbarium.
$clean_up=true;

// confirmation message
$confmsg = "\r\nFlag cultivated specimens in table `geoscrub` using proximity to herbaria? (Y=yes, N=no):";

///////////////////////////////////////////
// Include files
///////////////////////////////////////////
$path="../../";
include $path."db_config.inc";
include $path."../functions.inc";
include $path."../sql_functions.inc";

$timer_on=$path."timer_on.inc";
$timer_off_echo=$path."timer_off_echo.inc";

///////////////////////////////////////////
// Runtime error-reporting and screen echo
///////////////////////////////////////////
$echo_on = true;
$die_on_fail = true;
$msg_success = "done\r\n";

?>
