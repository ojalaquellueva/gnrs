#!/bin/bash

### Set all parameters and rename to params.sh ###

##############################################################
# Set the following parameters
# Substitute everything surrounded by <...> with actual parameter
##############################################################

# Path to database configuration file (db_config.sh)
# Recommend move outside app root directory (use absolute path)
# Omit trailing slash
db_config_path="../db_config.sh"

# Data directory name
# User input and results are saved here
# GNRS will look inside app directory (gnrs/) for this directory
# unless $data_dir_local_abs is set (next parameter)
# Omit trailing slash
data_base_dir="../data/user_data"		 # Relative path

# Absolute path to data directory
# Use this if data directory outside root application directory
# Comment out to use $data_base_dir (relative, above)
# Omit trailing slash
data_dir_local_abs="<absolute/path/to/data_directory>"

# Destination email for process notifications
# You must supply a valid email if you used the -m option
email="<your_email_address>"

##############################################################
# You shouldn't need to change these parameters in most cases
##############################################################

# Fuzzy match threshold (trigram similarity score)
# [0-1], recommend at least 0.5 to avoid false positives
match_threshold=0.5

# Default name of the raw data file to be imported. 
# This name will be used if no file name supplied as command line
# parameter. Must be located in the user_data directory
submitted_filename="gnrs_submitted.csv" 

# Name of results file
results_filename="gnrs_results.csv"

# 't' to limit number of records imported (for testing)
# 'f' to run full import
use_limit='f'
recordlimit=1000

# Short name for this operation, for screen echo and 
# notification emails. Number suffix matches script suffix
pname="GNRS"
pname_local=$pname

# General process name prefix for email notifications
pname_header_prefix="Process"