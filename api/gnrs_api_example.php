<?php

//////////////////////////////////////////////////////
// Submits test data to CDS API & displays results
//
// * Imports names from test file on local file system
// * Displays input and output at various stages of
// 	 the process.
//////////////////////////////////////////////////////

/////////////////////
// API parameters
/////////////////////

// api base url 
//$base_url = "http://vegbiendev.nceas.ucsb.edu:8775/cds_api.php"; 
$base_url = "http://vegbiendev.nceas.ucsb.edu:8875/gnrs_api.php"; // production
$base_url = "http://vegbiendev.nceas.ucsb.edu:9875/gnrs_api.php"; // development

require_once 'server_params.php';	// server-specific parameters 
require_once 'api_params.php';			// general api parameters

// Path and name of file containing input names and political divisions
$inputfile = $DATADIR."gnrs_testfile.csv";	// local test file
// $inputfile = $DATADIR."cds_testfile_big.csv";	// local test file (big)
// $inputfile = "https://bien.nceas.ucsb.edu/bien/wp-content/uploads/2020/10/cds_testfile.csv";

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

/////////////////////////////////////////
// GNRS options
//
// UNDER CONSTRUCTION! - NOT ALL OPTIONS
// CURRENTLY IMPLEMENTED
// 
// Set any option to empty string ("") to 
// use default
// *=default option
/////////////////////////////////////////

// Processing mode
//	Options: resolve*|meta
// 	E.g., $mode="meta"
$mode="resolve";			// Resolve names
$mode="meta";			// Return metadata on GNRS & sources

// Number of batches for parallel processing
$ppbatches=20;

/////////////////////////////////////////
// Display options
// 
// * Turn on/off what is echoed to terminal
// * Raw data always displayed
/////////////////////////////////////////

$disp_data_array=false;		// Echo raw data as array
$disp_combined_array=false;	// Echo combined options+data array
$disp_opts_array=false;		// Echo CDS options as array
$disp_opts=true;			// Echo CDS options
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
$options = getopt("b:m:");
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
if ( ! $batches=="" ) $opts_arr += array("batches"=>$batches);

///////////////////////////////
// Make data array
///////////////////////////////

// Import csv data and convert to array
$data_arr = array_map('str_getcsv', file($inputfile));

# Get subset
$data_arr = array_slice($data_arr, 0, $lines);

if ( $mode=="resolve" ) {
	// Echo raw data
	echo "The raw data:\r\n";
	foreach($data_arr as $row) {
		foreach($row as $key => $value) echo "$value\t"; echo "\r\n";
	}
	echo "\r\n";

	if ($disp_data_array) {
		echo "The raw data as array:\r\n";
		var_dump($data_arr);
		echo "\r\n";
	}
}

///////////////////////////////
// Merge options and data into 
// json object for post
///////////////////////////////

// Convert to JSON
if ($mode=='resolve') {
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

if ($disp_opts) {
	
	// Echo the options
	echo "CDS options:\r\n";
	//echo "  mode: " . $mode . "\r\n";
	//echo "  batches: " . $opts['batches'] . "\r\n";
	foreach($opts_arr as $key => $value) {
		//foreach($row as $key => $value) {
			echo "  $key=$value\n";
		//}
	}
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
	echo "API results as CSV:\r\n";
	
	foreach ( $results as $rkey => $row ) {
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
}

///////////////////////////////////
// Echo time elapsed
///////////////////////////////////

include $timer_off;	// Stop the timer
if ($time) echo "\r\nTime elapsed: " . $tsecs . " seconds.\r\n\r\n"; 

?>
