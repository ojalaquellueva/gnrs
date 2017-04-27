<?php

include "../db_config.inc";
include "../../functions.inc";
include "../../sql_functions.inc";

$timer_on="../timer_on.inc";
$timer_off_echo="../timer_off_echo.inc";

// Error-reporting and messages
$confmsg = "\r\nCreate table `geoscrub` in database `$DB_GEO`? (Y=yes, N=no):";
$echo_on = true;
$die_on_fail = true;
$msg_success = "done\r\n";

// create table scripts names
$drop_sql = "drop_tables.sql";
$create_sql = "create_tables.sql";

$geotbl="geoscrub";

?>
