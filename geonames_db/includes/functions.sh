#!/bin/bash

#################################################################
# General purpose shell functions
# Author: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 27 June 2016
#################################################################

checkemail()
{
	# Simple email validation function
	# Returns 0 if valid, 2 is missing, 1 if bad
	
	if [ -z "$1" ]; then
		# No email supplied
		#echo "No email supplied"
		return 2
	else 
		email=$1
	
		if [[ "$email" == ?*@?*.?* ]]  ; then
			#echo $email": Valid email"
			return 0
		else
			#echo $email": Bad email"
			return 1
		fi
	fi

}

echoi()
{
	# Echos message only if first token=true, otherwise does nothing
	# If optionally pass most recent exit code, will abort if error
	# Provides a compact alternative to wrapping echo in if...fi
	# Options:
	# 	-n 	Standard echo -n switch, turns off newline
	#	-e 	Exit status of last operation. If used, -e MUST be 
	#		followed by $? or $? saved as variable.
	# Gotcha: may behave unexpectedly if message = "true" or true

	# first token MUST be 'true' to continue
	if [ "$1" = true ]; then
		
		shift
		msg=""
		n=" "
		while [ "$1" != "" ]; do
			# Get remaining options, treating final 
			# token as message		
			case $1 in
				-n )			n=" -n "	
								shift
								;;
				-e )			shift
								rc=$1
								#echo "rc="$rc
								if [[ $rc != 0 ]]; then 
   									kill -s TERM $TOP_PID
								fi
								shift
								;;
				* )            	msg=$1
								break
								;;
			esac
		done	
		
		echo $n $msg
	fi
}

etime()
{
	# Returns elapsed time in seconds
	# Accepts: $prev, previous time 
	# Returns: difference between now and $prev
	
	now=`date +%s%N`
	prev=$1
	elapsed=`echo "scale=2; ($now - $prev) / 1000000000" | bc`
	echo $elapsed
}

