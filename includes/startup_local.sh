#!/bin/bash

#########################################################################
# Purpose: Loads parameters, functions & issues startup messages for  
# component scripts of pipeline. Detects whether script is running  
# indendently or has been called by master scripts as part of pipeline,
# and adjust parameters, settings and messages accordingly.
#########################################################################

# Get includes directory
includes_dir="${BASH_SOURCE%/*}"

# Load shared parameters if master script variable has not been set. 
if [ -z ${master+x} ]; then
	# reset master directory to parent directory
	DIR=$DIR_LOCAL
	
	# Load shared parameters & options files
	source "$includes_dir/get_params.sh"		# Parameters, files and paths
	source "$includes_dir/functions.sh"			# Load functions file
	source "$includes_dir/get_options.sh" 		# Get command line options
fi

# Load local parameters, if any
# Will over-write shared parameters of same name
if [ -f "$DIR_LOCAL/params.sh" ]; then
	source "$DIR_LOCAL/params.sh"

	###########################################################
	# Set data directory
	###########################################################

	# Change to absolute path if absolute path supplied
	if [ -n "$data_dir_local_abs" ]; then
		data_dir_local=$data_dir_local_abs
	else 
		# Assume path relative to app directory
		data_dir_local=$DIR_LOCAL"/"$data_base_dir
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
		source "$includes_dir/mail_process_start.sh"	# Email notification
	fi
	
	#########################################################################
	# Main
	#########################################################################

	echoi $e ""; echoi $e "------ Begin operation '$pname' ------"
	
fi
