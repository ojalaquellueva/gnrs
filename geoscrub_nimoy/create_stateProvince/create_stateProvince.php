<?php
// Builds and populates tables of standard names, synonymy, and languages
// in database geoscrub 
//
// Brad Boyle (bboyle@email.arizona.edu)
// 8 feb 2011

include "params.inc";	// everything you need to set is here and dbconfig.inc

if (confirm($confmsg)) {
	echo "\r\nBegin operation\r\n\r\n";
	include $timer_on;
}

// connect to database
if (!($dbh=db_connect($HOST,$USER,$PWD,$DB_GEO,$echo_on))) die();

echo "Creating tables...";
if (create_tables($create_sql,$drop_sql,$USER,$PWD,$DB_GEO)) {
	echo $msg_success;
} else {
	die();
}

include_once "import.inc";		// Import text files to staging tables
include_once "alter_staging_tables.inc"; // Adds plain ascii name fields to staging tables
include_once "convert_plain_ascii.inc";		// Converts all names to plain ascii equivalents
include_once "normalize.inc";		// Normalize contents of staging tables to final tables

// drop staging tables
echo "Dropping staging tables...";
foreach ($tbls_staging as $tbl) {
	if (delete_tbl($tbl, $DB_GEO)===false) echo "Error!\r\n";
}
echo "done\r\n";

mysql_close($dbh);
include $timer_off_echo;
echo "Operation completed\r\n\r\n";

?>
