<?php

////////////////////////////////////////////////////////
// Accepts batch web service requests and submits to 
// gnrs_batch.php
////////////////////////////////////////////////////////

///////////////////////////////////
// Parameters
///////////////////////////////////

include 'params.php';

// Get name of this file for error reporting
$currfile = basename(__FILE__);

// Temporary data directory
$data_dir_tmp = "/tmp/gnrs";

// Input file
$basename = uniqid(rand(), true);
$filename_tmp = $basename . '.csv';

// Results file
$results_filename = $basename . "_gnrs_results.csv";

///////////////////////////////////
// Functions
///////////////////////////////////

// Load a CSV file as array
function csvtojson($file,$delimiter,$lines) {
	$filename = basename($file);
    
    if (($handle = fopen($file, "r")) === false) {
    	//$err_msg = "ERROR: Can't open file '" . basename($file) . 
    	//	"' (script: '" . basename(__FILE__) . "')";
    	$err_msg = "ERROR: Can't open file '" . $file . 
    		"' (script: '" . basename(__FILE__) . "')";
    	die($err_msg);
    }

    $f_csv = fgetcsv($handle, 4000, $delimiter);
    $f_array = array();

    while ($row = fgetcsv($handle, 4000, $delimiter)) {
            $f_array[] = array_combine($f_csv, $row);
    }

    fclose($handle);
    
    // Get subset of array
    $f_array = array_slice($f_array, 0, $lines);
    
    // Convert and return the JSON
    return json_encode($f_array);
}

///////////////////////////////////
// Receive & validate the POST request
///////////////////////////////////

// Check request is a POST
if (strcasecmp($_SERVER['REQUEST_METHOD'], 'POST') != 0) {
    throw new Exception('Request method must be POST!');
}
 
// Check content type of the POST request has been set to application/json
$contentType = isset($_SERVER["CONTENT_TYPE"]) ? trim($_SERVER["CONTENT_TYPE"]) : '';
if (strcasecmp($contentType, 'application/json') != 0) {
    throw new Exception('Content type must be: application/json');
}
 
// Load the raw POST data.
$input_json = trim(file_get_contents("php://input"));

// Attempt to decode the incoming RAW post data from JSON.
$input_array = json_decode($input_json, true);

// If json_decode failed, then JSON is invalid.
if (!is_array($input_array)) {
    throw new Exception('Received content contained invalid JSON!');
}

///////////////////////////////////
// Inspect the JSON data and run 
// safety/security checks
///////////////////////////////////


///////////////////////////////////
// Convert JSON and save to data 
// directory as CSV file
///////////////////////////////////

// Make temporary data directory & file in /tmp 
$cmd="mkdir -p $data_dir_tmp";
exec($cmd, $output, $status);
if ($status) die("ERROR: Unable to create temp data directory");

$file_tmp = $data_dir_tmp . "/" . $filename_tmp;

// Convert array to CSV input file & save to data directory
$fp = fopen($file_tmp, "w");
$i = 0;
foreach ($input_array as $row) {
    if ($i === 0) fputcsv($fp, array_keys($row));	// header
    fputcsv($fp, array_values($row));				// data
    $i++;
}
fclose($fp);

///////////////////////////////////
// Process the CSV file in batch mode
///////////////////////////////////

$cmd="./gnrs_batch.sh -p -s -f '$file_tmp'";
exec($cmd, $output, $status);
if ($status) die("ERROR: gnrs_batch non-zero exit status ($status)");

///////////////////////////////////
// Retrieve the tab-delimited results
// file and convert to JSON
///////////////////////////////////

// Import the results file
$results_file = $data_dir_tmp . "/" . $results_filename;
$results_json = csvtojson($results_file, ",",100000);

///////////////////////////////////
// Echo the results
///////////////////////////////////

header('Content-type: application/json');
echo $results_json;

?>