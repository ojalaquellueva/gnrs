<?php
// Everything you need to set is here and in dbconfig.inc

// includes
include "../db_config.inc";	// connection info and name of database
include "../../functions.inc";
include "../../sql_functions.inc";

// Error-reporting and echo behaviour at runtime
$echo_on = true;
$die_on_fail = true;
$msg_success = "done\r\n";

// confirmation message
$confmsg = "\r\Update geovalidation tables in bien2 database? (Y=yes, N=no):";

// create table scripts names
$drop_sql = "drop_tables.sql";
$create_sql = "create_tables.sql";

// table names
$geotbl1="geoIndividualObservation";
$geotbl2="geoPlotMetaDataDimension";

?>
