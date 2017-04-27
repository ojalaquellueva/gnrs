<?php
// Creates empty table `geoscrub` in geoscrub database
// and populates with original record IDs and verbatim 
// locality values from main database

include "params.inc"; // everything you need to set is here

if (confirm($confmsg));

// connect to database
if (!($dbh=db_connect($HOST,$USER,$PWD,$DB_GEO,$echo_on))) die();

// If tables already exists, confirm delete before continue
$tbl=$geotbl;
if (exists_table($tbl)) {
	$msg="Existing table `$tbl` will be deleted! Continue? (y/n)";
	if (confirm($msg)){
		// OK to proceed; connection not needed
		echo "\r\nBegin operation\r\n";
		mysql_close($dbh);
	}
}
include $timer_on; // start timer
	
echo "Creating tables...";
if (create_tables($create_sql,$drop_sql,$USER,$PWD,$DB_GEO)) echo $msg_success;

// connect to database
if (!($dbh=db_connect($HOST,$USER,$PWD,$DB_GEO,$echo_on))) die();

// insert records from source db
include_once "insert_records.inc"; 

// Close connection and report time elapsed
mysql_close($dbh);
include $timer_off_echo;
echo "Operation completed\r\n\r\n";

?>
