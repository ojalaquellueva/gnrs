#!/bin/bash

#########################################################################
# Purpose: Checks exit status of immediate preceding operation 
#
# If fail, exit with preceding exist status code. Optionally sends  
# failure notification email. If success, echoes success message  
# (interactive mode only) & resets time elapsed.
#
# Parameters needed:
#	$?				Current exist status code
#	$m				Email option; "true"/"false"
#	$prev			Start time of most recent process
#	$pname_header	Email header for current process 
#	$pid			Process ID of top-level script
#	$email			Email address, should be validated already
#	$e				echo on (=interactive mode); "true"/"false"
#
# Requires function echoi()
#
# Keeping this in separate script allows it to be used by individual
# pipeline scripts run on their own
#########################################################################


if [[ $? != 0 ]]; then 
	if [[ "$m" = "true" ]]; then
		now=`date`
		subject=$pname_header" FAILED!"
		msg="Process PID "$pid" failed at "$now
		echo "$msg"`date` | mail -s "$subject" $email; 
	fi
	exit $rc
else
	elapsed=$(etime $prev); prev=`date +%s%N`
	echoi $e "done ($elapsed sec)"
fi