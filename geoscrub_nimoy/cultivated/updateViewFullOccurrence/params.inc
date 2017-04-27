<?php
// Everything you need to set is here and in dbconfig.inc

///////////////////////////////////////////
// Application parameters
///////////////////////////////////////////

// confirmation message
$confmsg = "\r\nUpdate isCultivated fields in table `viewFullOccurence`? (Y=yes, N=no):";

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
