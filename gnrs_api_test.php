<?php

///////////////////////////////////////////////////////////////
// Script for testing GNRS API
//
// Usage:
//	php gnrs_ws_test.php
//
// Purpose: 
//	Use to test GNRS API on command line. Imports CSV test data
//	file (directory & file of your choice), restructures as json,  
//	echoes json to screen, sends to GNRS api as POST  
//	request, echoes response (will see json if successful).
//
// Parameters (set in parameters section below, not on command line):
// 	$ws_data_dir: Directory of test file (utf-8 text CSV with header)
//	$inputfilename: Name of test file
// 	$lines: Number of lines of test file to import
//	$api_host: Host (and port, if applicable) of API
//  
// Input file format: see below
//  
// Author: Brad Boyle (bboyle@email.arizona.edu)
///////////////////////////////////////////////////////////////

// $me=basename(__FILE__); exit("\r\nExiting $me...\r\n");

/*

Input file requirements

Rules:
* UTF-8 CSV test with header
* Column country mandatory
* Column state_province required only if country_parish included

Fields:
user_id	- user-supplied unique identifier (text; optional)
country	- country name (text; required)
state_province - state/province name (text; optional)
county_parish - next lower political division (text; optional)

Header: 
user_id,country,state_province,county_parish

Format:
user_id,country,state_province,county_parish
row1_user_id,row1_country,row1_state_province,row1_county_parish
row2_user_id,row2_country,row2_state_province,row2_county_parish
row3_user_id,row3_country,row3_state_province,row3_county_parish
...

Example input file (note user_id not used):
user_id,country,state_province,county_parish
,United States,Arizona,Pima County
,Russia,Lipetsk,Dobrovskiy rayon
,Mexico,"Sonora, Estado de",Huépac
,Guatemala,Izabal,El Estor

*/

/////////////////////////////////////////////
// Parameters
//
// Adjust the following parameters according
// to your installation and test data
/////////////////////////////////////////////

// Data directory
// Input and output files here
$ws_data_dir = "../data/user/";					// Relative path
//$ws_data_dir = "/home/bien/gnrs/data/user/";    // Absolute path

// Test file of political division names
$inputfilename = "test_data.csv";		# Test file name (small)

// Number of lines of test file to import, not counting header
// Handy for testing a small sample of larger file
// Set to empty string ("") to impart entire file
$lines = "5";

// API host (+port, as applicable)
// Virtual Host and ports must be configured appropriately
// Examples formats:
// $api_host = "<server_name>"
// $api_host = "<server_name>:<port>"
// $api_host = "<server_ip>"
// $api_host = "<server_ip>:<port>"
// $api_host = "localhost";
// $api_host = "127.0.0.0";
// $api_host = "localhost:<port>";
// $api_host = "127.0.0.0:<port>";
$api_host = "http://vegbiendev.nceas.ucsb.edu:8875";	// production
$api_host = "http://vegbiendev.nceas.ucsb.edu:9875";	// development

/////////////////////////////////////////////
// Functions
/////////////////////////////////////////////

function csvtoarray($file,$delimiter,$lines)
{
    if (($handle = fopen($file, "r")) === false) {
    	die("can't open the file.");
    }

    $f_csv = fgetcsv($handle, 4000, $delimiter);
    $f_array = array();

    while ($row = fgetcsv($handle, 4000, $delimiter)) {
            $f_array[] = array_combine($f_csv, $row);
    }

    fclose($handle);
    $f_array = array_slice($f_array, 0, $lines); // Get requested subset
    
    return $f_array;
}

/////////////////////////////////////////////
// Main
/////////////////////////////////////////////

echo "\r\nTesting GNRS API\r\n";

//
// Form the API base url
//

$api_url = $api_host . "/gnrs_ws.php";

// Echo it
echo "\r\nGNRS API host:\r\n'$api_host'\r\n";

//
// Load the input file
//

// Set to very large number to import entire file
// if $lines parameter blank
if ($lines=="") $lines=1000000000;

// Input file name and path
$inputfile = $ws_data_dir.$inputfilename;
if (!file_exists($inputfile)) die("Input file '$inputfile' doesn't exist!\r\n");
echo "\r\nInput file:\r\n";
echo $inputfile . "\r\n";

// Get total lines in file
$file = new \SplFileObject($inputfile, 'r');
$file->seek(PHP_INT_MAX);
$flines = $file->key(); 

// Echo the file
echo "\r\nInput file contents:\r\n";
$csv_arr = file($inputfile);
for ($i=0; $i<min($lines+1,$flines); $i++) echo $csv_arr[$i];

// Convert to JSON & echo
$csv_arr = csvtoarray($inputfile,',',$lines);
$json_data = json_encode($csv_arr);
echo "\r\nJSON data sent:\r\n";
echo $json_data . "\r\n";

//
// Prepare the API request
//

// Call the batch api
$url = $api_url;    
$content = $json_data;

// Initialize curl request
$ch = curl_init($url);	

// Option: return response (CRITICAL!)
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

// Option: POST request
curl_setopt($ch, CURLOPT_POST, 1);	

// Set the header
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json')); 

// Attach the encoded JSON
curl_setopt($ch, CURLOPT_POSTFIELDS, $json_data);	

//
// Send the request
//

// Execute the API call
$response = curl_exec($ch);

//
// Process the response
//

// Check status of the response and echo if error
$status = curl_getinfo($ch, CURLINFO_HTTP_CODE);

if ( $status != 201 && $status != 200 ) {
    die("Error: call to URL $url failed with status $status, response $response, curl_error " . curl_error($ch) . ", curl_errno " . curl_errno($ch) . "\r\n");
}

// Close curl
curl_close($ch);

//
// Echo the response
//

echo "\r\nThe response:\r\n";
var_dump($response);

?>
