<?php

///////////////////////////////////////////////////////////////
// Assembles test batch request and submits to GNRS API
// Imports names from file on local file sysytem
///////////////////////////////////////////////////////////////

/////////////////////
// Parameters
/////////////////////

// Path and name of file containing input names and political divisions
$ws_data_dir = "/home/boyle/bien3/gnrs/user_data/";
$inputfilename = "gnrs_testfile.csv";

// Desired response format, json or xml
// NOT USED YET
$format="json";

// Number of lines to import
// Set to large number to impart entire file
$lines = 100000;

// api base url 
$base_url = "http://vegbiendev.nceas.ucsb.edu:9875/gnrs_ws.php";

/////////////////////
// Functions
/////////////////////

function csvtojson($file,$delimiter,$lines)
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
    
    // Get subset of array
    $f_array = array_slice($f_array, 0, $lines);
    
    // Convert and return the JSON
    return json_encode($f_array);
}

/////////////////////
// Main
/////////////////////

//
// Load the input file
//

// Import the csv data and convert a sample of it to JSON
$inputfile = $ws_data_dir.$inputfilename;
$json_data = csvtojson($inputfile, ",",$lines);

// Echo the input
echo "\r\nInput data before sending:\r\n";
echo $json_data . "\r\n";

//
// Prepare the API request
//

// Call the batch api
$url = $base_url;    
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
// Send the request and process the response
//

// Execute the API call
$response = curl_exec($ch);

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