<?php

///////////////////////////////////////////////////////////////////////////
/*
Geographic Name Resolution Service

Core GNRS batch processing application
Validates combinations of country+state_province+county_parish
Return format is csv

To execute, run /var/www/bien/apps/nsr/nsr_batch.php

Input: CSV file, "gnrs_input.csv" in user_data/
	country - required
	state_province - optional, but required if county_parish present
	county_parish - optional
	user_id - optional; INTEGER UNSIGNED

Output: tab-delimited file, "nsr_results.txt", in user_data/
	country_verbatim - as submitted by user
	state_province_verbatim - as submitted by user
	county_parish_verbatim - as submitted by user
	user_id - as submitted by user
	country - standard plain-ascii English name, if matched
	state_province - standard plain-ascii English name, if matched
	county_parish - standard plain-ascii English name, if matched
	country_geonameid - if matched
	state_province - if matched
	county_parish - if matched
	poldiv_submitted - Lowest political division submitted ('c', 'sp', 'cp')
	poldiv_matched - Lowest political division matched ('c', 'sp', 'cp')
*/ 
///////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////
// Parameters
//////////////////////////////////////////////////////

// Get db connection parameters (in ALL CAPS)
include 'params.php';
include $CONFIG_DIR.'db_config.php';
include $batch_includes_dir.'batch_params.php';

//////////////////////////////////////////////////////
// Options
//////////////////////////////////////////////////////

$shortopts  = "";
$shortopts .= "e::"; 	// command line echo (true/on;false/off [default])
$shortopts .= "i::"; 	// interactive mode (true/on;false/off [default])
$shortopts .= "f::"; 	// file name, if provided will over-ride 
						// default name in params.inc
$shortopts .= "t::"; 	// file type (csv [default], tab)
$shortopts .= "l::"; 	// line endings (mac [default], unix, win)
$shortopts .= "r::"; 	// replace cache and re-run all species 
						// (true/on;false/off [default])

// get command line arguments, if any
$options = getopt($shortopts);

// Command line echo
$echo_on = true;
if (array_key_exists('e', $options)) {
	$e = $options["e"];
	if ($e === false || $e == 'false' || $e == 'off') {
		$echo_on = false;
	} else {
		$echo_on = true;
	}
}

// Interactive mode
$interactive = false;
if (array_key_exists('i', $options)) {
	$i = $options["i"];
	if ($i === true || $i == 'true' || $i == 'on') $interactive = true;
}
if ($interactive===true) $echo_on=true;	// If interactive mode, echo MUST be on

// Input file name
if (array_key_exists('f', $options)) {
	// Over-ride default input file name from params file
	$file = $options["f"];
	if ($file<>false) $inputfilename = $file;		
}

// Input file type
$filetype='csv';
if (array_key_exists('t', $options)) {
	$t = $options["t"];
	if($t == "tab") {
		// tab-delimitted
		// Otherwise assumes CSV, as set in params file
		$fields_terminated_by = " FIELDS TERMINATED BY '\t' ";
		$optionally_enclosed_by = " ";  
		$filetype='tab-delimited';
	}	
}

// Input file line endings
if (array_key_exists('l', $options)) {
	// By default assumes mac line endings,
	// as set in params file
	$l = $options["l"];
	switch ($l) {
		case "unix":
			// Unix
			$lines_terminated_by = " LINES TERMINATED BY '\n' ";
			break;
		case "win":
			// Windows
			$lines_terminated_by = " LINES TERMINATED BY '\r\n' ";
			break;
	}	
}

// parameters $inputfilename and $resultsfilename in 
// batch_params.php, but can
$inputfile = $BASE_URL.$DATADIR.$inputfilename;

// Set name of result file based on input file
$pizza = explode('.',$inputfilename);
if (count($pizza)>1) {
	$lastpiece = array_pop($pizza);
	$ext = '.'.$lastpiece;
} else {
	$ext = '';
}
$resultsfilename = str_replace($ext,'',$inputfilename) . "_nsr_results.txt";
$resultsfile = $BASE_URL.$DATADIR.$resultsfilename;

// Replace cache?
// Default=false
// If true, will re-run all observations through the NSR,
// replacing any existing values in cache
$replace_cache = false;
if (array_key_exists('r', $options)) {
	$r = $options["r"];
	if ($r === true || $r == 'true' || $r == 'on') $replace_cache = true;
}
$replace_cache===true?$replace_cache_str='true':$replace_cache_str='false';

//////////////////////////////////////////////////////
// Confirm operation and connect to database
//////////////////////////////////////////////////////

if ($interactive) {
	$msg = "
Run NSR batch application with following parameters:
	
NSR database: $DB
Input file: $inputfilename
File type: $filetype
Results file: $resultsfilename
Replace cache: $replace_cache_str

Enter Y to proceed, N to cancel: "
	;
	$proceed=responseYesNoDie($msg);
	if ($proceed===false) die("\r\nOperation cancelled\r\n");
}

if ($echo_on) {
	// Start timer and connect to mysql
	echo "\r\n*********Begin operation*********\r\n\r\n";
	include $timer_on;
}

//////////////////////////////////////////////////////
// Process the file
//////////////////////////////////////////////////////

if(file_exists($inputfile)) {
	/* connect to the db */
	include 'db_batch_connect.php';
	
	// create new observation table
	include_once $batch_includes_dir."create_observation_batch.php";	

	// Import raw observations to temporary table
	include_once $batch_includes_dir."create_observation_raw.php";	
	include_once $batch_includes_dir."import_raw_observations.php";
	
	// insert raw observations
	include_once $batch_includes_dir."insert_observations.php";					
	
	// perform any standardizations needed
	
	if ($echo_on) echo "Standardizing observations...";
	include_once "standardize_observations.php";
	if ($echo_on) echo $done;	

	if ($replace_cache===true) {
		// Remove cached observations for these species+poldiv combinations
		if ($echo_on) echo "Removing previous observations from cache...";
		include_once "remove_observations_from_cache.php";
		if ($echo_on) echo $done;	
	} else {
		// Mark records already in cache
		if ($echo_on) echo "Marking observations already in cache...";
		include_once "mark_observations.php";	
		if ($echo_on) echo $done;	
	}
	
	include 'db_batch_connect.php';
		
	// Process observations not in cache, if any, then add to cache
	// Do only if >=1 observations not in cache
	$sql="
	SELECT COUNT(*) AS rows
	FROM observation
	WHERE is_in_cache=0
	;
	";
	//$result = mysql_query($sql);	
	//$num_rows = mysql_num_rows($result);
	$num_rows = sql_get_first_result($sql,'rows');

	if ($num_rows>0) {
		if ($echo_on) echo "Resolving $num_rows new observations...";
		include_once "nsr.php";	
		if ($echo_on) echo "$done";
	}
		
	if ($replace_cache===false) {
		// update observation table from cache
		// Not necessary if $replace_cache is true
		include_once $batch_includes_dir."update_observations.php";		
	}
	
	// dump nsr results to text file
	include_once $batch_includes_dir."dump_nsr_results.php";			
	//exit ("Exiting...\r\n\r\n");
} else {
	die("\r\nError: file '$inputfile' not found!\r\n");
}

//////////////////////////////////////////////////////
// Close connection and report time 
//////////////////////////////////////////////////////

if ($echo_on) {
	include $timer_off;
	$msg = "\r\n********* Operation completed *********";
	$msg = $msg . "\r\nCurrent time: ". $curr_time;
	$msg = $msg . "\r\nTime elapsed: " . $tsecs . " seconds.\r\n"; 

	echo $msg . "\r\n\r\n"; 
}

?>