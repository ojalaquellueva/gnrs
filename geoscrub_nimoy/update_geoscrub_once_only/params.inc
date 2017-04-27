<?php

include "../db_config.inc";
include "../../functions.inc";
include "../../sql_functions.inc";

$timer_on="../timer_on.inc";
$timer_off_echo="../timer_off_echo.inc";

// confirmation messages
$confmsg = "\r\nUpdate geovalidation results to table `geoscrub`? (Y=yes, N=no):";

// Error-reporting and echo behaviour at runtime
$echo_on = true;
$die_on_fail = true;
$msg_success = "done\r\n";

$geotbl="geoscrub";

?>
