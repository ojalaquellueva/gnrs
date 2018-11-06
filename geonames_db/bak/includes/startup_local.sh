#!/bin/bash

#########################################################################
# Purpose: Loads parameters, functions & issues startup messages for  
# component scripts of pipeline. Detects whether script is running  
# indendently or has been called by master scripts as part of pipeline,
# and adjust parameters, settings and messages accordingly.
#########################################################################

# Load shared parameters if master script variable has not been set. 
if [ -z ${master+x} ]; then
	# reset master directory to parent directory
	DIR=$DIR_LOCAL"/.."
	
	# Load shared parameters & options files
	source "$DIR/includes/get_params.sh"	# Parameters, files and paths
	source "$DIR/includes/get_functions.sh"	# Load functions file(s)
	source "$DIR/includes/get_options.sh" # Get command line options
fi

# Load local parameters, if any
# Will over-write shared parameters of same name
if [ -f "$DIR_LOCAL/params.sh" ]; then
	source "$DIR_LOCAL/params.sh"

	# Local data directory will be under main data directory
	# and will have same name as base name of local file
	# Make sure it exists if you intend to use it with this
	# script!
	#data_dir_local=$data_dir"/"$local_basename
	
	###########################################################
	# Set local data directory
	#
	# If absolute path was(optionally) defined in local params 
	# file, then use this value. If not defined, then set path 
	# here relative to main data directory, using same name 
	# as base name of local file for final subdirectory.
	# Make sure data directory exists if you intend to use it!
	###########################################################

	# Assume relative path
	data_dir_local=$data_dir"/"$local_basename

	# Change to absolute path if absolute path supplied
	if [ -n "$data_dir_local_abs" ]; then
		if [[ $data_dir_local_abs == /* ]]; then
			data_dir_local=$data_dir_local_abs
		fi
	fi

fi	

# Load shared parameters if master script variable has not been set. 
if [ -z ${master+x} ]; then	
	# Substitute local process name if running independently
	pname=$pname_local
	pname_header=$pname_local_header

	######################################################
	# Confirm operation (interactive mode only), start
	# timer & send confirmation email if requested
	######################################################

	if [[ "$i" = "true" ]]; then 
		# Reset confirmation message
		msg_conf="$(cat <<-EOF

		Run process '$pname'? 
		Warning: SLOW...Run in unix screen session!
		EOF
		)"		
		confirm "$msg_conf"
	fi
	start=`date +%s%N`; prev=$start		# Get start time
	pid=$$								# Set process ID
	if [[ "$m" = "true" ]]; then 
		source "$DIR/includes/mail_process_start.sh"	# Email notification
	fi
	
	#########################################################################
	# Main
	#########################################################################

	echoi $e ""; echoi $e "------ Begin operation '$pname' ------"
	
fi
