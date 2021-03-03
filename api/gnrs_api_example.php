<?php

// ************************************************************
// WARNING: Not up to date! See gnrs_api_example.R for new calls
// ************************************************************

//////////////////////////////////////////////////////
// Submits test data to GNRS API & displays results
//
// * Imports names from test file on local file system
// * Displays input and output at various stages of
// 	 the process.
// * 
//////////////////////////////////////////////////////

/////////////////////////////////////////
// API processing options
/////////////////////////////////////////

// Processing mode
$mode="resolve";		// Resolve names
$mode="countrylist";	// Return information on all countries
$mode="statelist";		// Return info on all states; country_id param required
$mode="countylist";		// Return info on all counties; state_id param required
$mode="meta";			// Return metadata on application & sources

// Number of batches for parallel processing
$ppbatches=20;

/////////////////////
// API parameters
/////////////////////

// api base url 
$base_url = "http://vegbiendev.nceas.ucsb.edu:8875/gnrs_api.php"; // production
$base_url = "http://vegbiendev.nceas.ucsb.edu:9875/gnrs_api.php"; // development
//$base_url = "http://paramo.cyverse.org/gnrs/gnrs_api.php";        // paramo

require_once 'params.php';			// general parameters 
require_once 'api_params.php';		// api-specific parameters

// Path and name of file containing input names and political divisions
$inputfile = $DATADIR."gnrs_testfile.csv";	// local test file
//$inputfile = "https://bien.nceas.ucsb.edu/bien/wp-content/uploads/2020/11/gnrs_testfile.csv";

// Desired response format
//	Options: json*|xml
// Example: $format="xml";
// NOT YET IMPLEMENTED!
$format="json";

// Number of lines to import
// Use this option to limit test data to small subsample of input file
// Set to number > # of lines in file to import entire file
$lines = 10000000000;
//$lines = 5;

//////////////////////////////////////////
// Test data from routes statelist & countylist
//////////////////////////////////////////

// List of country_ids 'Costa Rica, Nicaragua, Panama)
$country_ids="3624060,3617476,3703430";
$country_ids="";

// List of example state_province IDs
$state_ids="3624953,3624368,3830308,3620673";
//$state_ids="";
$state_ids="3624953,3624368,3830308,hello world!";

/////////////////////////////////////////
// Display options
// 
// * Turn on/off what is echoed to terminal
// * Raw data always displayed
/////////////////////////////////////////

$disp_data_array=false;		// Echo raw data as array
$disp_combined_array=false;	// Echo combined options+data array
$disp_opts_array=false;		// Echo application options as array
$disp_opts=true;			// Echo application options
$disp_json_data=true;		// Echo the options + raw data JSON POST data
$disp_results_json=true;	// Echo results as array
$disp_results_array=false;	// Echo results as array
$disp_results_csv=true;		// Echo results as CSV text
$time=true;					// Echo time elapsed

/////////////////////////////////////////////////////
// Command line options
// Use to over-ride the above parameters
/////////////////////////////////////////////////////

// Get options, set defaults for optional parameters
// Use default if unset
$options = getopt("m:b:");
$mode=isset($options["m"])?$options["m"]:$mode;	
$batches=isset($options["b"])?$options["b"]:$ppbatches;	

////////////////////////////////////////////////////////////////
// Main
////////////////////////////////////////////////////////////////

include $timer_on; 	// Start the timer
echo "\n";

///////////////////////////////
// Set options array
///////////////////////////////
$opts_arr = array(
	"mode"=>$mode
	);
if ( $mode=="resolve" && (! $batches=="" ) ) {
	$opts_arr += array("batches"=>$batches);
}
	
///////////////////////////////
// Display options and confirm
///////////////////////////////

if ($disp_opts) {	
	// Echo the options
	echo "$APPNAME options:\r\n";
	foreach($opts_arr as $key => $value) {
		//foreach($row as $key => $value) {
			echo "  $key=$value\n";
		//}
	}
	echo $mode=="resolve"?"  input file: $inputfile \n":"";
	echo "  API url: $base_url \n";
	echo "\r\n";
}

$batches=isset($options["b"])?$options["b"]:$ppbatches;	


// Confirm above options before proceeding
$message   =  "Execute API call with above settings? [y/n]";
print $message;
// flush();
// ob_flush();
$confirmation  =  trim( fgets( STDIN ) );
if ( $confirmation !== 'y' ) {
   exit (0);
}

///////////////////////////////
// Make data array
///////////////////////////////

if ( $mode=="resolve" ) {
	// Import csv data and convert to array
	$data_arr = array_map('str_getcsv', file($inputfile));

	# Get subset
	$data_arr = array_slice($data_arr, 0, $lines);

	$lines_in = 0;

	// Echo raw data
	echo "The raw data:\r\n";
	foreach($data_arr as $row) {
		foreach($row as $key => $value) echo "$value\t"; echo "\r\n";
		$lines_in++;
	}
	echo "\r\n";
	
	$lines_in = $lines_in-1;
	echo "\nInput rows (minus header): $lines_in\n\n";

	if ($disp_data_array) {
		echo "The raw data as array:\r\n";
		var_dump($data_arr);
		echo "\r\n";
	}
} else if ( $mode=="statelist" ) {
	$val_arr=explode(",",$country_ids);
	foreach($val_arr as $value) {
		$data_arr[] = array('country_id' => $value);
	}	
} else if ( $mode=="countylist" ) {
	$val_arr=explode(",",$state_ids);
	foreach($val_arr as $value) {
		$data_arr[] = array('state_id' => $value);
	}	
}

///////////////////////////////
// Merge options and data into 
// json object for post
///////////////////////////////

// Convert to JSON
if ($mode=='resolve' || $mode=='statelist' || $mode=='countylist' ) {
	# Options + data
	$json_data = json_encode(array('opts' => $opts_arr, 'data' => $data_arr));	
} else {
	# Just options
	$json_data = json_encode(array('opts' => $opts_arr));	
}

///////////////////////////////
// Decompose the JSON
// into opt and data
///////////////////////////////

$input_array = json_decode($json_data, true);

if ($disp_combined_array) {
	echo "The combined array:\r\n";
	var_dump($input_array);
	echo "\r\n";
}

$opts = $input_array['opts'];
if ($disp_opts_array) {
	echo "Options array:\r\n";
	var_dump($opts);
	echo "\r\n";
}

if ($disp_json_data) {
	// Echo the final JSON post data
	echo "API input (options + raw data converted to JSON):\r\n";
	echo $json_data . "\r\n\r\n";
}

///////////////////////////////
// Call the API
///////////////////////////////

$url = $base_url;    

// Initialize curl & set options
$ch = curl_init($url);	
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);	// Return response (CRITICAL!)
curl_setopt($ch, CURLOPT_POST, 1);	// POST request
curl_setopt($ch, CURLOPT_POSTFIELDS, $json_data);	// Attach the encoded JSON
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json')); 

// Send the API call
$response = curl_exec($ch);

// Check status of the response and echo if error
$status = curl_getinfo($ch, CURLINFO_HTTP_CODE);

if ( $status != 201 && $status != 200 ) {
	$status_msg = $http_status_codes[$status];
	$msg="Error: call to URL $url failed with status $status $status_msg \r\nDetails: $response \r\n";
    //die($msg);
    echo $msg;
}

// Close curl
curl_close($ch);

///////////////////////////////
// Echo the results
///////////////////////////////

$results_json = $response;
$results = json_decode($results_json, true);	// Convert JSON results to array

// Echo the JSON response
if ($disp_results_json) {
	echo "API results (JSON)\r\n";
	echo $results_json;
	echo "\r\n\r\n";
}

if ($disp_results_array) {
	echo "API results as array:\r\n";
	var_dump($results);
	echo "\r\n\r\n";
}

if ($disp_results_csv) {
	$lines_out = 0;
	echo "API results as CSV:\r\n";
	
	foreach ( $results as $rkey => $row ) {
		$lines_out++;
		$rind=array_search( $rkey, array_keys($results) );	# Index: current row
		$cindmax = count( $row )-1;	// Index: last column of current row
	
		if ( $rind==0 ) {
			// Print header
			foreach ( $row as $key => $value )  {	
				$cind=array_search( $key, array_keys($row) );
				$cind==$cindmax?$format="%1s\n":$format="%1s,";
				printf($format, $key);
			}
		}

		// Print data 
		foreach ( $row as $key => $value )  {	
			$cind=array_search( $key, array_keys($row) );
			$cind==$cindmax?$format="%1s\n":$format="%1s,";
			printf($format, $value);
		}
	}
	
	$lines_out = $lines_out-1;
	echo "\nOutput rows (minus header): $lines_out\n\n";
}

///////////////////////////////////
// Echo time elapsed
///////////////////////////////////

include $timer_off;	// Stop the timer
if ($time) echo "\r\nTime elapsed: " . $tsecs . " seconds.\r\n\r\n"; 

?>
