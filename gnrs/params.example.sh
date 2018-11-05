#!/bin/bash

### Set all parameters and rename to params.sh ###

##############################################################
# Application parameters
# Check and change as needed
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

# Path to db_config.sh
# For production, keep outside app working directory & supply
# absolute path
# For development, if keep inside working directory, then supply
# relative path
# Omit trailing slash
db_config_path="<path/to/db_config_file_directory>"

# Path to general function directory
# If directory is outside app working directory, supply
# absolute path, otherwise supply relative path
# Omit trailing slash
#functions_path=""
functions_path="<path/to/functions_file_directory>"

# Path to data directory
# Recommend call this "data"
# If directory is outside app working directory, supply
# absolute path, otherwise use relative path (i.e., no 
# forward slash at start).
# Recommend keeping outside app directory
# Omit trailing slash
data_dir_local_abs="</absolute/path/to/>gnrs/userdata"
#data_base_dir="data/userdata"		 # Relative path

# Destination email for process notifications
# You must supply a valid email if you used the -m option
email="<your_email_address>"

# Short name for this operation, for screen echo and 
# notification emails. Number suffix matches script suffix
pname="GNRS"
pname_local=$pname

# General process name prefix for email notifications
pname_header_prefix="Process"