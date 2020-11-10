<?php

/////////////////////////////////////////////////
// Server-specific parameters
// Keep outside repo to preserve settings
/////////////////////////////////////////////////

// Application base directory
$BASE_DIR = "/home/boyle/bien/gnrs/";

// API directory
$APP_DIR = $BASE_DIR."src/api/";

// Batch application source directory
$BATCH_DIR=$BASE_DIR."src/";

// dir where db user & pwd file kept
// Should be outside application directory and html directory
$CONFIG_DIR = $BASE_DIR . "config/"; 

// Input & output data directory
$DATADIR = $BATCH_DIR."data/user/";	// For production, keep outside API directory

// Path and name of log file
$LOGFILE_NAME = "log.txt";
$LOGFILE_PATH = $APP_DIR;
$LOGFILE = $LOGFILE_PATH . $LOGFILE_NAME;

// Path to general php funcions and generic include files
$utilities_path=$APP_DIR."php_includes/php/";	// Local submodule directory

// General php funcions and generic include files
include $utilities_path."functions.inc";
include $utilities_path."taxon_functions.inc";
include $utilities_path."sql_functions.inc";
include $utilities_path."status_codes.inc.php";
$timer_on=$utilities_path."timer_on.inc";
$timer_off=$utilities_path."timer_off.inc";

?>
