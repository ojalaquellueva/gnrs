#!/bin/bash

#########################################################################
# Purpose: Loads parameters, functions & issues startup messages for  
# component scripts of pipeline. Detects whether script is running  
# indendently or has been called by master scripts as part of pipeline,
# and adjust parameters, settings and messages accordingly.
#########################################################################

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
