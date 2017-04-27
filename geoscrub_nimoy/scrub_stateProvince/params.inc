<?php
// Everything you need to set is here and in dbconfig.inc

// includes
include "../db_config.inc";	// connection info and name of database
include "../../functions.inc";
include "../../sql_functions.inc";

$timer_on="../timer_on.inc";
$timer_off_echo="../timer_off_echo.inc";

// Error-reporting and echo behaviour at runtime
$echo_on = true;
$die_on_fail = true;
$msg_success = "done\r\n";

///////// table & column names /////////
$tblgeo="geoscrub";

// scrubbing table
$poldiv="stateProvince";
$poldivID=$poldiv."ID";
$poldivScrubbed="stateProvinceScrubbed";
$poldivPlainAscii=$poldivScrubbed."PlainAscii";
$tblPoldivScrubbed=$poldivScrubbed;
$poldivVerbatim="stateProvinceVerbatim";

// standard name & code table
$tblPoldivStd=$poldiv;		// standard name table for this poldiv
$uniqueCodeFld = "HASC_1";	// name of unique code field in standard table
$dependentCodeFld = "stateProvinceCode";	// name of dependent code field in standard table; requires parent poldiv as well
$poldivStd=$poldiv."NameStd";	// name of column containing standardized name in standard name table

// synonym table
$tblPoldivSyn=$poldiv."Name";	// name of synonym table
$poldivSynName=$tblPoldivSyn;	// name of poldiv name column

// standard table of parent political division
$poldivParent="country";
$tblPoldivParent=$poldivParent;	// name of parent table
$poldivParentID=$poldivParent."ID";	// name of PK of parent table
					// this should be the same in all tables!
$poldivParentName=$poldiv."NameStd";	// name of standard poldiv name column
///////// END table & column names /////////

// confirmation message
$confmsg = "\r\nValidate $poldiv names from table $tblgeo? (Y=yes, N=no):";

// create table scripts names
$drop_sql = "drop_tables.sql";
$create_sql = "create_tables.sql";

;

?>
