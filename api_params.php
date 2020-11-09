<?php

/////////////////////////////////////////////////
// API tuning parameters
/////////////////////////////////////////////////

// Return offending SQL on error? (true|false)
// TURN OFF FOR PRODUCTION! ($err_show_sql=false)
$err_show_sql=false;

// Maximum permitted input rows per request
// For no limit, set to 0
$MAX_ROWS=5000;	
					
// Number of batches
$NBATCH=20;				

//////////////////////////////////////////////////
// API user options
//////////////////////////////////////////////////

# Options "resolve" & "parse" go to TNRSbatch, but other options
# query database directly
$MODES = array("resolve","meta");


//////////////////////////////////////////////////
// default options
//////////////////////////////////////////////////

$DEF_MODE = "resolve";		// Processing mode

?>
