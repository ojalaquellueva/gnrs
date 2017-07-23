<?php
// Everything you need to set is here and in dbconfig.inc

// includes
include "db_config.inc";	// connection info and name of database
include "functions.inc";
include "sql_functions.inc";

// Error-reporting and echo behaviour at runtime
$echo_on = true;
$die_on_fail = true;
$msg_success = "done\r\n";

// Name of source tables
// Names of geovalidation tables constructed by adding "geo" prefix
$tbl_ind="IndividualObservation";
$tbl_plot="PlotMetaDataDimension";

// confirmation message
$confmsg = "\r\nUpdate geovalidation tables in bien2 database? (Y=yes, N=no):";

?>
