<?php
// Everything you need to set is here and in dbconfig.inc

///////////////////////////////////////////
// Application parameters
///////////////////////////////////////////

// confirmation message
$confmsg = "\r\nUpdate isCultivated field in table `geoscrub`? (Y=yes, N=no):";

///////////////////////////////////////////
// Include files
///////////////////////////////////////////
$path="../../";
include $path."db_config.inc";
include $path."../global_utilities/functions.inc";
include $path."../global_utilities/sql_functions.inc";

$timer_on=$path."../global_utilities/timer_on.inc";
$timer_off_echo=$path."../global_utilities/timer_off_echo.inc";

///////////////////////////////////////////
// Runtime error-reporting and screen echo
///////////////////////////////////////////
$echo_on = true;
$die_on_fail = true;
$msg_success = "done\r\n";

?>
