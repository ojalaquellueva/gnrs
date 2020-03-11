#!/bin/bash

######################################################
# Confirm operation (interactive mode only), start
# timer & send confirmation email if requested
######################################################

if [[ "$i" = "true" ]]; then 
	# Construct confirmation message
	# Displayed in interactive mode in effect
	msg_conf="$(cat <<-EOF

	Run process "$pname"? 
	EOF
	)"
	confirm "$msg_conf";
fi
start=`date +%s%N`; prev=$start		# Get start time
pid=$$								# Get process ID
if [[ "$m" = "true" ]]; then 
	source "$DIR/includes/mail_process_start.sh"	# Email notification
fi

echoi $e ""; echoi $e "------ Begin operation '$pname' ------"
echoi $e ""