#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
# MUST load config/db_config.sh first to set $BASEDIR
##############################################################

# $BASE_DIR is server specific and therefore kept in 
# server_config.sh in config directory outside repo
source "../config/server_config.sh";

##########################
# Paths, adjust according  
# to your installation
##########################

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

# Default batch size. Recommend 10000. Input files smaller than this number
# (I.e., fewer lines) will be processed as single batch.
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
# Set debug mode
#
# Values: t|f
# t: debug mode on
#	* clears cache and all previous user data before start
#	* echoes parameters for gnrs_batch and gnrs to file in data directory
#	* Retains user data for current run in DB for inspection
# f: debug mode off
#	* Turns off echo-params-to-file
#	* Clears user data for current run from DB after operation complete
#
# Make sure debug_mode='f' for production!!!
##########################

debug_mode='f'

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
pname_header_prefix="Process"
