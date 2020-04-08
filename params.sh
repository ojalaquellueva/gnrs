#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

##########################
# Paths, adjust according  
# to your installation
##########################

# Absolute path to base directory for this application
# Install the application code (from repo) inside a 
# subdirectory of the base directory
BASEDIR="/home/boyle/bien/gnrs"

# Path to db_config.sh
# For production, keep outside app directory & supply absolute path
# Omit trailing slash
db_config_path="${BASEDIR}/config"

# Relative data directory name
# GNRS will look here inside app directory for user input
# and will write results here, unless $data_dir_local_abs
# is set (next parameter)
# Omit trailing slash
data_base_dir="data/user"		

# Absolute path to data directory
# Use this if data directory outside root application directory
# Comment out to use $data_base_dir (relative, above)
# Omit trailing slash
data_dir_local_abs="${BASEDIR}/data/user"
#data_dir_local_abs="/home/boyle/bien3/repos/gnrs/data/user_data"

# For backward-compatibility
data_dir_local=$data_dir_local_abs

#############################################################
# Normally shouldn't have to change remaining parameters
#############################################################

##########################
# Batch & multi-user
# parameters
##########################

# Default batch size. Recommend 10000
batch_size=10000;

##########################
# Default input/output file names
##########################

# Default name of the raw data file to be imported. 
# This name will be used if no file name supplied as command line
# parameter. Must be located in the user_data directory
submitted_filename="gnrs_submitted.csv" 

# Default name of results file
results_filename="gnrs_results.csv"

##########################
# Fuzzy match parameters
##########################

# Fuzzy match threshold (trigram similarity score)
# [0-1], recommend at least 0.5 to avoid false positives
match_threshold=0.5

##########################
# Input subsample parameters
##########################

# 't' to limit number of records imported (for testing)
# 'f' to run full import
use_limit='f'
recordlimit=1000

##########################
# Display/notification parameters
##########################

# Destination email for process notifications
# You must supply a valid email if you used the -m option
email="bboyle@email.arizona.edu"

# Short name for this operation, for screen echo and 
# notification emails. Number suffix matches script suffix
pname="GNRS"
pname_local=$pname

# General process name prefix for email notifications
pname_header_prefix="BIEN notification: process"
