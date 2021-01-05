<?php

/////////////////////////////////////////////////
// API tuning parameters
/////////////////////////////////////////////////

// Maximum permitted input rows per request
// For no limit, set to 0
$MAX_ROWS=5000;	
				
// Default number of batches
// Makeflow will default to lower number if input lines < $NBATCH
// Am having issues with lost lines when $NBATCH># cores, so set
// this number = # of cores, until I can solve issue
$NBATCH=20;		

// Echo offending SQL on error? (true|false)
// TURN OFF FOR PRODUCTION! ($err_show_sql=false)
$err_show_sql=false;

//////////////////////////////////////////////////
// API allowable options, for validation
//////////////////////////////////////////////////

$MODES = array("resolve","meta");

//////////////////////////////////////////////////
// Default option values
//////////////////////////////////////////////////

$DEF_MODE = "resolve";		// Processing mode

?>
