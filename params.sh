#!/bin/bash

##############################################################
# Application parameters
##############################################################

# Relative path to server-specific configuration file.
# Currently contains only one parameter, $BASE_DIR, which
# is the absolute path to the immediate parent of this
# directory (i.e., the repo). Recommend keep server_config.sh
# in $BASE_DIR/config/
currdir=$(dirname ${BASH_SOURCE[0]})
source "${currdir}/../config/server_config.sh";

#################################
# You should not need to change
# the remaining parameters unless 
# you alter default configuration
#################################

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
# Replace user_data
##########################

# Purge user_data after each call of gnrs_batch?
# Generally good idea to avoid bloat & slow performance
clear_user_data='t'

# Clear entire user_data_table
clear_user_data_all='f'

##########################
# Fuzzy match parameters
##########################

# Default fuzzy match threshold (trigram similarity score)
# [0-1], recommend at least 0.5 to avoid false positives
match_threshold=0.5
DEF_MATCH_THRESHOLD=0.5

##########################
# Input subsample parameters
##########################

# 't' to limit number of records imported (for testing)
# 'f' to run full import
use_limit='f'

# Ignored if use_limit='f'
recordlimit=100000

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
# Make sure debug_clear_all='f' for production!!!
##########################

# Save debugging file of key parameters
debug_mode='f'

# Clear all user data and cache to avoid confusion with previous jobs
# TURN OFF FOR PRODUCTION!!!
debug_clear_all='f'

##########################
# Display/notification parameters
##########################

# Short name for this operation, for screen echo and 
# notification emails. Number suffix matches script suffix
pname="GNRS"
pname_local=$pname

# General process name prefix for email notifications
pname_header_prefix="Process"
