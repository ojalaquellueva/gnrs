<?php
// Creates and populates table `[poldiv]Scrubbed` in geoscrub database
// `[poldiv]Scrubbed` contains each unique verbatim poldiv string
// in geoscrubbing table.
// Scrubs and indexes names by comparison against table of standard names
// and table of synonym names
//
// Brad Boyle (bboyle@email.arizona.edu)
// 9 November 2010

include "params.inc";	// everything you need to set is here and dbconfig.inc

if (confirm($confmsg)) {
	echo "\r\nBegin operation\r\n\r\n";
	include $timer_on;
}

// connect to database
if (!($dbh=db_connect($HOST,$USER,$PWD,$DB_GEO,$echo_on))) die();

echo "Creating table `$tblPoldivScrubbed`...";
if (create_tables($create_sql,$drop_sql,$USER,$PWD,$DB_GEO)) echo $msg_success;

include_once "insert_names.inc";	// insert unique names from geoscrub table
include_once "scrub_names.inc";  	// scrub and index names
include_once "update.inc";  		// copy results to geoscrub table

mysql_close($dbh);
include $timer_off_echo;
echo "Operation completed\r\n\r\n";;

?>
