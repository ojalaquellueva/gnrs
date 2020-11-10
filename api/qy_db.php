<?php

////////////////////////////////////////////////////////
// Queries database with supplied sql ($sql)
////////////////////////////////////////////////////////

// require_once 'server_params.php';	// server-specific parameters
// require_once 'api_params.php';		// API option parameters

include $CONFIG_DIR.'db_config.php';

// On error, display SQL if request (turn off for production!)
if ( $err_show_sql ) {
	$sql_disp = $sql;
} else {
	$sql_disp = "";
}

// connect to the db
$conn_string = "host=$HOST port=5432 dbname=$DB user=$USER_W password=$PWD_USER_W";
$dbconn = pg_connect($conn_string);

// check connection
if (!$dbconn) {
	echo "Database connection failed\n";
	exit();
}

// Execute the query
if (!$qy_results = pg_query($dbconn, $sql)) {
	die("Cannot execute query: '$sql_disp'\n"); 
} 

// Create associative array of the query results
$results_array = array();
if(pg_num_rows($qy_results)) {
	while($result = pg_fetch_assoc($qy_results)) {
		//$results_array[] = array($mode=>$result); // Include $mode
		$results_array[] = $result;					// Omit $mode
	}
}

// Close the connection
pg_close($dbconn); 

?>