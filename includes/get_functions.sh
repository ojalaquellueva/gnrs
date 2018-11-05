#!/bin/bash

#########################################################################
# Purpose: Loads functions files
#
# $DIR set by main script
# $functions_path set in parameters file, must be called previously
#
# Keeping this in separate script allows it to be used by individual
# pipeline scripts run on their own
#########################################################################

# Load functions
if [[ $functions_path == /* ]]; then
	# Absolute path
	source "$functions_path/functions.sh"
else
	#Relative path
	source "$DIR/$functions_path/functions.sh"
fi

