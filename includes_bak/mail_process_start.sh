#!/bin/bash

#########################################################################
# Purpose: Sends email notification of process start 
#
# Parameters, must be called first:
#	$email:			Valid email address
#	$pname_header:	Process name, set by user in params.inc file
#	$pid:			Parent process id (set by main script)
#
# Requires function checkemail()
#
# Keeping this in separate script allows it to be used by individual
# pipeline scripts run on their own
#########################################################################

# Check sure valid email supplied in params file
checkemail $email; result=$?

if [[ $result -eq 0 ]]; then
	#Set mail parameters
	now=`date`
	process=$pname_header
	subject=$process" started"
	msg="Process PID "$pid" started: "$now
	
	echo "$msg" | mail -s "$subject" $email
elif [[ $result -eq 1 ]]; then
	echo "Bad email (using -m option)"
	#exit 1
else
	echo "No email supplied (using -m option)"
	#exit 1
fi