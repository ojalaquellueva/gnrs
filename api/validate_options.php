<?php

//////////////////////////////////////////////
// Validate options passed to API
//
// Note that if multiple errors detected, only
// the last gets reported
//////////////////////////////////////////////
// Processing mode
if (array_key_exists('mode', $opt_arr)) {
	$mode = $opt_arr['mode'];
	
	if ( trim($mode) == "" ) {
		$mode = $DEF_MODE;
	} else {
		$valid = in_array($mode, $MODES);
		if ( $valid === false ) {
			$err_msg="ERROR: Invalid option '$mode' for 'mode'\r\n"; 
			$err_code=400; $err=true;
		}
	}
} else {
	$mode = $TNRS_DEF_MODE;
}

// Threshold parameter $maxdist
if (array_key_exists('maxdist', $opt_arr)) {
	$maxdist = $opt_arr['maxdist'];
	
	if ( trim($maxdist) == "" ) {
		$maxdist = ""; // Core app will use defalt value
	} else {
		$valid = false;
		if ( is_numeric($maxdist) )  {
			if ( $maxdist>0 && ( is_int($maxdist) || ctype_digit($maxdist) ) ) {
				$valid=true;
			}
		} 
	
		if ( $valid === false ) {
			$err_msg="ERROR: Option 'maxdist' must be integer >0 \r\n"; 
			$err_code=400; $err=true;
		}
	}
}

// Threshold parameter $maxdistrel
if (array_key_exists('maxdistrel', $opt_arr)) {
	$maxdistrel = $opt_arr['maxdistrel'];
	
	if ( trim($maxdistrel) == "" ) {
		$maxdistrel = ""; // Core app will use defalt value
	} else {
		$valid = false;
		if ( is_numeric($maxdistrel) )  {
			$maxdistrel= (float) $maxdistrel;
			if ( $maxdistrel>0 && $maxdistrel<1 ) $valid=true;
		} 
	
		if ( $valid === false ) {
			$err_msg="ERROR: Option 'maxdistrel' must proportion over [0:1] \r\n"; 
			$err_code=400; $err=true;
		}
	}
}



/////////////////////////////////////////////
// Other options
/////////////////////////////////////////////

// Number of batches for makeflow threads
// If not set, uses default $NBATCH
if (array_key_exists('batches', $opt_arr)) {
	$batches = $opt_arr['batches'];
	
	if ( $batches==intval($batches) ) {
		$NBATCH = $batches;
	} else {
		$err_msg="ERROR: Invalid value '$batches' for option 'batches': must be an integer\r\n"; $err_code=400; $err=true;
	}
}

?>