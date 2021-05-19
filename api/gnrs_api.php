<?php

////////////////////////////////////////////////////////
// Accepts batch API POST requests and submits to GNRS
// (gnrspar.sh: parallel version)
////////////////////////////////////////////////////////

///////////////////////////////////
// Parameters
///////////////////////////////////

// Increase memory limit for this script only
// Allows sending of larger reponses
ini_set('memory_limit','1000M');

# Delimiter of results file returned by core application
$results_file_delim = "\t";

// parameters in ALL_CAPS set in the two params files
require_once 'params.php';			// general parameters 
require_once 'api_params.php';		// API option parameters

// Temporary data directory
$data_dir_tmp = $DATADIR;
$data_dir_tmp = "/tmp/gnrs/";

// Input file name & path
// User JSON input saved to this file as pipe-delimited text
// Becomes input for tnrs_batch command (`./controller.pl [...]`)
$basename = "gnrs_" . uniqid(rand(), true);

$filename_tmp = $basename . '_in.tsv';
$file_tmp = $data_dir_tmp . $filename_tmp;

// Results file name & path
$results_filename = $basename . "_out.csv";
//$results_filename = $basename . "_cds_scrubbed.csv";

# Full path and name of results file
$results_file = $data_dir_tmp . $results_filename;
//$results_file = "/tmp/" . $results_filename;

///////////////////////////////////
// Functions
///////////////////////////////////

////////////////////////////////////////////////////////
// Loads results file as an asociative array
// 
// Options:
//	$filepath: path and name of file to import
//	$delim: field delimiter
////////////////////////////////////////////////////////

function file_to_array_assoc($filepath, $delim) {
	$array = $fields = array(); $i = 0;
	$handle = @fopen($filepath, "r");
	if ($handle) {
		while (($row = fgetcsv($handle, 4096, $delim , '"' , '"')) !== false) {
			// Load keys from header row & continue to next
			if (empty($fields)) {
				$fields = $row;
				continue;
			}
			
			// Load value for this row 
			foreach ($row as $k=>$value) {
				$array[$i][$fields[$k]] = $value;
			}
			$i++;
		}
		if (!feof($handle)) {
			echo "Error: unexpected fgets() fail\n";
		}
		fclose($handle);
	}
	
	return $array;
}

////////////////////////////////////////////////////////
// Convert a 2-level nested array to SQL IN-list
// of the 2nd-level elements
// Assumes:
// * Level 2 has one element & no further nesting
// * Each element is a number not requiring quotes
////////////////////////////////////////////////////////

function make_inlist(array $in) {
		$inlist = "";
		foreach ($in as $row) {
			$inlist .= implode(array_values($row)) . ",";
		}
		// Remove trailing comma
		$inlist = rtrim($inlist, ",");
		return $inlist;
}

////////////////////////////////////////////////////////
// Convert a 2-level nested array to SQL IN-list
// of the 2nd-level elements
// Assumes:
// * Level 2 has one element & no further nesting
// * Each element is a string that must be quoted
// Not currently used but keep for future use
////////////////////////////////////////////////////////

function make_inlist_quoted(array $in) {
		$inlist = "'";
		foreach ($in as $row) {
			$inlist .= implode(array_values($row)) . "','";
		}
		// Remove trailing comma + opening single quote
		// For some reason need to re-add closing quote
		$inlist = rtrim($inlist, ",'") . "'";
		return $inlist;
}

////////////////////////////////////////////////////////
// Convert a 2-level nested array to SQL AND...OR
// component of WHERE clause
//
// Assumes level 2 has two elements & no further nesting
// * The 2 elements are joined with AND surrounded by parentheses
// * Each 2-element pair separated from the next by OR
// * Each element is a number that does not require quotes
//
// Parameters:
//	$vals: Values of the two elements
//	$col1: SQL column name of the 1st element
//	$col2: SQL column name of the 2nd element
////////////////////////////////////////////////////////

function make_sql_andor (array $vals, $col1, $col2) {
		$andor = "(${col1}=";
		foreach ($vals as $row) {
			$andor .= implode(" AND ${col2}=", array_values($row)) . ") OR (${col1}=";
		}
		// Remove trailing OR
		$andor = rtrim($andor, " OR (${col1}=");
		return $andor;
}

////////////////////////////////////////
// Receive & validate the POST request
////////////////////////////////////////

// Start by assuming no errors
// Any run time errors and this will be set to true
$err_code=0;
$err_msg="";
$err=false;

// Make sure request is a pre-flight request or POST
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
	// Send pre-flight response and quit
	//header("Access-Control-Allow-Origin: http://localhost:3000");	// Dev
	header("Access-Control-Allow-Origin: *"); // Production
	header("Access-Control-Allow-Methods: POST, OPTIONS");
	header("Access-Control-Allow-Headers: Content-type");
	header("Access-Control-Max-Age: 86400");
	exit;
} else if (strcasecmp($_SERVER['REQUEST_METHOD'], 'POST') != 0) {
	$err_msg="ERROR: Request method must be POST\r\n"; 
	$err_code=400; goto err;
}
 
// Make sure that the content type of the POST request has been 
// set to application/json
$contentType = isset($_SERVER["CONTENT_TYPE"]) ? trim($_SERVER["CONTENT_TYPE"]) : '';
if (strcasecmp($contentType, 'application/json') != 0) {
	$err_msg="ERROR: Content type must be: application/json\r\n"; 
	$err_code=400; goto err;
}
 
// Receive the RAW post data.
$input_json = trim(file_get_contents("php://input"));

///////////////////////////////////////////
// Convert post data to array and separate
// data from options
///////////////////////////////////////////

// Attempt to decode the incoming RAW post data from JSON.
$input_array = json_decode($input_json, true);

// If json_decode failed, the JSON is invalid.
if (!is_array($input_array)) {
	$err_msg="ERROR: Received content contained invalid JSON!\r\n";	
	$err_code=400; goto err;
}

///////////////////////////////////////////
// Extract & validate options
///////////////////////////////////////////

// Get options and data from JSON
if ( ! ( $opt_arr = isset($input_array['opts'])?$input_array['opts']:false ) ) {
	$err_msg="ERROR: No API options (see element 'opts' in JSON request)\r\n";	
	$err_code=400; goto err;
}

///////////////////////////////////
// Sanitize the JSON options
///////////////////////////////////

// UNDER CONSTRUCTION!

///////////////////////////////////////////
// Validate options and assign each to its 
// own parameter
///////////////////////////////////////////

include $APP_DIR . "validate_options.php";
if ($err) goto err;

///////////////////////////////////////////
// Check option $mode
// If "meta", ignore other options and begin
// processing metadata request. Otherwise 
// continue processing TNRSbatch request
///////////////////////////////////////////

if ( $mode=="resolve" || $mode=="statelist"|| $mode=="countylist") {

	///////////////////////////////////////////
	// Extract & validate data
	///////////////////////////////////////////

	// Get data from JSON
	if ( !( $data_arr = isset($input_array['data'])?$input_array['data']:false ) ) {
		$err_msg="ERROR: No data (element 'data' in JSON request)\r\n";	
		$err_code=400; goto err;
	}

	# Check payload size
	$rows = count($data_arr);
	if ( $rows>$MAX_ROWS && $MAX_ROWS>0 ) {
		$err_msg="ERROR: Requested $rows rows exceeds $MAX_ROWS row limit\r\n";	
		$err_code=413;	# 413 Payload Too Large
		goto err; 
	}

	# Validate data array structure
	# Should have 1 or more rows of exactly $ncols elements each
	$rows=0;
	if ( $mode=="resolve" ) {
		$ncols=4;
	} else if ( $mode=="statelist" || $mode=="countylist" ) {
		$ncols=1;	// country_id or state_province_id
	}
	
	foreach ($data_arr as $row) {
		$rows++;
		$values=0;
		foreach($row as $value) $values++;
		if ($values<>$ncols) {
			$err_msg="ERROR: Data has wrong number of columns in one or more rows, should be exactly $ncols for mode='$mode'\r\n"; $err_code=400; goto err;
		}
	}
	if ($rows==0) {
		$err_msg="ERROR: No data rows!\r\n"; $err_code=400; goto err; 
	}
}

///////////////////////////////////
// Sanitize the JSON data
///////////////////////////////////

if ( $mode=="resolve" ) {

	// UNDER CONSTRUCTION
	
} else if ( $mode=="statelist" || $mode=="countylist") {
	// Check that all input values are integer ids
	$params = implode(",", $data_arr[0]);
	if ( ! $params=="" ) {
		foreach($data_arr as $row) {
			foreach($row as $key=>$value) {
				if (!filter_var($value, FILTER_VALIDATE_INT) === true) {
				  $err_msg="ERROR: Value $key='$value' not a valid integer ID!\n"; $err_code=400; goto err;
				}
			}
		}
	}
}

if ( $mode == 'resolve' ) { 	// BEGIN mode_if
	///////////////////////////////////
	// Process the CSV file in parallel mode
	///////////////////////////////////

	# Get parallel batch size, if set, otherwise use default
	if ( isset($batches) ) {
		$nbatches = $batches;
	} else {
		$nbatches = $NBATCH;
	}
	
	# Reset batches to 2 if 1 (b=1 failing for some reason)
	if ( $nbatches==1 ) $nbatches=2;

	///////////////////////////////////////////
	// Save data array to temp directory as 
	// comma-delimited file, to be used as 
	// input for CDS core app
	///////////////////////////////////////////

	// Make temporary data directory & file in /tmp 
	$cmd="mkdir -p $data_dir_tmp";
	exec($cmd, $output, $status);
	if ($status) {
		$err_msg="ERROR: Unable to create temp data directory\r\n";	
		$err_code=500; goto err;
	}

	// Convert array to file & save
	$fp = fopen($file_tmp, "w");
	$i = 0;
	foreach ($data_arr as $row) {
		//if($i === 0) fputcsv($fp, array_keys($row));	// header
		fputcsv($fp, array_values($row), ',');	// data
		$i++;
	}
	fclose($fp);

	// Run dos2unix to fix stupid DOS/Mac/Excel/UTF-16 issues
	$cmd = "dos2unix $file_tmp";
	exec($cmd, $output, $status);
	//if ($status) die("ERROR: tnrs_batch non-zero exit status");
	if ($status) {
		$err_msg="Failed file conversion: dos2unix for file ${file_tmp}\r\n";
		$err_code=500; goto err;
	}

	$data_dir_tmp_full = $data_dir_tmp . "/";
	// Form the final command
	$cmd = $BATCH_DIR . "gnrspar.pl -in '$file_tmp'  -out '$results_file' -nbatch $nbatches ";
	
	// Process the data in parallel batches with the core application
	exec($cmd, $output, $status);
	if ($status) {
		$err_msg="ERROR: $APPNAME exit status: $status\r\n";
		$err_code=500; goto err;
	}

	///////////////////////////////////
	// Retrieve the tab-delimited results
	// file and convert to JSON
	///////////////////////////////////
	
	// Import the results file (tab-delimitted) to array
	$results_array = file_to_array_assoc($results_file, $results_file_delim);

} else {	// CONTINUE mode_if 
	// Metadaa & other requests that query DB directly
	// No need for parallel processing

	if ( $mode=="meta" ) { 
		$sql="
		SELECT db_version, build_date, code_version 
		FROM meta
		;
		";
	} else if ( $mode=="dd" ) { 
		// Retrieve output data dictionary
		$sql="
		SELECT col_name, ordinal_position, data_type, description
		FROM dd_output
		ORDER BY ordinal_position
		;
		";
	} else if ( $mode=="countrylist" ) { 
		// Retrieve complete list of all countries
		$sql="
		SELECT country_id, country, iso, iso_alpha3, fips, 
		continent_code, continent,
		gid_0 AS gadm_gid_0
		FROM country
		;
		";
	} else if ( $mode=="statelist" ) { 
		// Turn rows of countries into SQL "IN" clause
		$params = implode(",", $data_arr[0]);
		if ( $params == "" ) {
			// Get everything (no WHERE clause)
			$sql_where = " ";
		} else {
			// Turn list of IDs into SQL "IN" clause
			$countries = make_inlist($data_arr);
			$sql_where = "WHERE country_id in ($countries) ";
		}
		
		// Form the final SQL
		$sql="
		SELECT state_province_id, country_id, country_iso, country,
		state_province, 
		state_province_ascii, 
		state_province_std AS state_province_gnrs,
		state_province_code_full AS iso_3866_1, 
		state_province_code2_full AS iso_3866_1_alt, 
		hasc_full AS hasc,
		gid_0 AS gadm_gid_0,
		gid_1 AS gadm_gid_1
		FROM state_province
		$sql_where
		ORDER BY country, state_province
		;
		";
	} else if ( $mode=="countylist" ) { 
		$params = implode(",", $data_arr[0]);
		if ( $params == "" ) {
			// Get everything (no WHERE clause)
			$sql_where = " ";
		} else {
			// Turn list of IDs into SQL "IN" clause
			$states = make_inlist($data_arr);
			$sql_where = "WHERE state_province_id IN ($states) ";
		}

		// Form the final SQL
		$sql="
		SELECT county_parish_id, country_id, country, country_iso,
		state_province_id, state_province_ascii,
		county_parish, county_parish_ascii,
		county_parish_std AS county_parish_gnrs,
		county_parish_code_full AS iso_3166_2,
		county_parish_code2_full AS iso_3166_2_alt,
		hasc_2_full AS hasc2,
		gid_0 AS gadm_gid_0,
		gid_1 AS gadm_gid_1,
		gid_2 AS gadm_gid_2
		FROM county_parish	
		$sql_where
		ORDER BY country, state_province, county_parish
		;
		";
	} else {
		$err_msg="ERROR: Unknown opt mode '$mode'\r\n"; 
		$err_code=400; goto err;
	}
	
	// Run the query and save results as $results_array
	include("qy_db.php"); 

}	// END mode_if

$results_json = json_encode($results_array);
//$results_json = "sql:\n $sql \n";	// For troubleshooting

///////////////////////////////////
// Send the response
///////////////////////////////////

// Send the header
header("Access-Control-Allow-Origin: *");
header('Content-type: application/json');

// Send data
echo $results_json;
//echo "cmd:\n $cmd \n";	// For troubleshooting

///////////////////////////////////
// Error: return http status code
// and error message
///////////////////////////////////

err:
//http_response_code($err_code);
echo $err_msg;
//echo "cmd:\n $cmd \n";	// For troubleshooting
//echo "sql:\n $sql \n";	// For troubleshooting

?>
