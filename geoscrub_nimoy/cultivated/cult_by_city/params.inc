<?php
// Everything you need to set is here and in dbconfig.inc

///////////////////////////////////////////
// Application parameters
///////////////////////////////////////////

// Relationship between city population and area:
// lnP = 2.25 + 0.4529*lnA
// where P=population and A=area in km2
// Based on linear regression of population and area
// for US cities, with intercept decreased to 
// describe a conservative lower bound
// Therefore,
// lnA = ( lnP - 2.25 ) / 0.4529
// A = exp ( ( lnP - 2.25 ) / 0.4529 )
// Therefore, distance in km to "perimeter" of city", or R (radius)=
// R = SQRT(A / Pi)
$slope = 2.25;
$intercept = 0.4529;

// Set to true to remove temporary table
// of IDs and distance to nearest herbarium.
// Otherwise false.
// You may want to keep this table if you need to examine
// properties of observations as a function of distance
// to nearest herbarium.
$clean_up=false;

// confirmation message
$confmsg = "\r\nFlag cultivated specimens in table `geoscrub` using proximity to cities? (Y=yes, N=no):";

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
