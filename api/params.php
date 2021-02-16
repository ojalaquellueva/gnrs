<?php

/////////////////////////////////////////////////
// Paths and include files
/////////////////////////////////////////////////

// Server-specific parameters $APPNAME & $BASE_DIR loaded from 
// server parameters file in config directory one
// level above (outside) application directory (=repo). 
// Template for this file is in src/config/server_params.php
include "../../config/server_params.php";

// API directory
$APP_DIR = $BASE_DIR."src/api/";

// Batch application source directory
$BATCH_DIR=$BASE_DIR."src/";

// dir where db user & pwd file kept
// Should be outside application directory and html directory
$CONFIG_DIR = $BASE_DIR . "config/"; 

// Input & output data directory
// For production keep outside API directory
$DATADIR = $BASE_DIR."data/user/";	

// Path and name of log file
$LOGFILE_NAME = "log.txt";
$LOGFILE_PATH = $APP_DIR;
$LOGFILE = $LOGFILE_PATH . $LOGFILE_NAME;

// Path to general php funcions and generic include files
$utilities_path=$APP_DIR."php_utilities/";	// Local submodule directory

// General php funcions and generic include files
include $utilities_path."functions.inc";
include $utilities_path."taxon_functions.inc";
include $utilities_path."sql_functions.inc";
include $utilities_path."status_codes.inc.php";
$timer_on=$utilities_path."timer_on.inc";
$timer_off=$utilities_path."timer_off.inc";

?>
