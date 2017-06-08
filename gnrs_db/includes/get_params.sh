#!/bin/bash

#########################################################################
# Purpose: Loads parameters and paths 
#
# Keeping this in separate script allows it to be used by individual
# pipeline scripts run on their own
#########################################################################

# Load parameters file
source "$DIR/params.sh"

# Load db configuration params
if [[ "$db_config_path" == "" ]]; then
	source "$DIR/db_config.sh"
else
	source "$db_config_path/db_config.sh"	
fi

# Set data directory
if [[ $data_dir != /* ]]; then
	# Set relative path
	data_dir="$DIR/$data_base_dir"
else
	# Use absolute path
	data_dir=$data_base_dir
fi

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private