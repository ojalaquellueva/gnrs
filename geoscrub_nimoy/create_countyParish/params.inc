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

// create table scripts names
$drop_sql = "drop_tables.sql";
$create_sql = "create_tables.sql";

// Political-division-specific parameters
// These are the ONLY parameters you should have to change
// to make script process and different political division
$poldiv="countyParish";			// Political division
$poldivHascCode="HASC_2";		// HASC code name for this political division
$tbl_std_index_prefix="cp_";		// make sure this is a globally unique table name abbreviation within database
$tbl_syn_index_prefix="cpn_";		// make sure this is a globally unique table name abbreviation within database
$poldivParent="stateProvince";

///////// table & column names /////////
// Names of tables to be created and populated
$tbl_std=$poldiv;			// standard table, one record per unique political division
$poldivUniqueCode=$poldiv."UniqueCode";	// Name of field containing unique text code for this political division
$tbl_syn=$poldiv."Name"; 		// synonymy table, multiple records (alternate spelling) in multiple languages, per political division
$tbl_staging_suffix="Staging"; 		// suffix for staging tables
$tbl_std_staging=$tbl_std.$tbl_staging_suffix;	
$tbl_syn_staging=$tbl_syn.$tbl_staging_suffix;	
$tbl_std_staging_poldiv=$poldiv."NameStd";
$poldivTypeFld="polDivTypeEng";		// Name of field for English-language name of type of political division
$tbl_syn_staging_poldiv=$poldiv."Name";
$tbl_lang="language";			// table of languages and standard codes
$tbl_lang_syn=$tbl_syn."_".$tbl_lang;	// table linking languages to synonyms
$tbl_std_pk=$tbl_std."ID"; 		// name of PK of standard table
$tbl_syn_pk=$tbl_syn."ID"; 		// name of PK of synonym table
$asciiNameFld=$poldiv."NamePlainAscii";	// field added to staging tables to hold plain ascii version of names

// standard table of parent political divisions
$tblPoldivParent=$poldivParent;	// name of parent table
$poldivParentID=$poldivParent."ID";	// name of PK of parent table
					// this should be the same in all tables!
$poldivParentName=$poldiv."NameStd";	// name of standard poldiv name column
$poldivParentUniqueCode=$poldivParent."UniqueCode";	// Name of a text code which uniquely identifies the parent poldiv
					// For country, this would be ISO code
					// may need to make up codes for other political divisions
///////// END table & column names /////////

// The names the text file to be imported
// should be identical except for delimiter (see below)
// otherwise script will fail
// Delimiters of text files must be identical (see below)
$tbls = array(
	$tbl_std,
	$tbl_syn
);
$tbls_staging = array(
	$tbl_std_staging,
	$tbl_syn_staging
);

// Extension, if any, appended to end of table name to make name
// of corresponding text file
// make sure your raw data files conform to this naming standard
// E.g., if poldiv is "stateProvince" and $ext is ".csv" then
// file must be named "stateProvince.csv"
$ext=".txt";

// Import parameters for text files
// Needed for 'LOAD DATA INFILE' statement
// Set any variable to empty string to remove entirely
$local = " LOCAL ";	// LOCAL keyword
$fields_terminated_by = " FIELDS TERMINATED BY ',' ";
$optionally_enclosed_by = " OPTIONALLY ENCLOSED BY '\"' ";
$lines_terminated_by = " LINES TERMINATED BY '\n' ";
$ignore_lines = " IGNORE 1 LINES ";

// confirmation message
$confmsg = "\r\nBuild tables `$tbl_std` and `$tbl_syn` in geoscrub database? (Y=yes, N=no):";

?>
