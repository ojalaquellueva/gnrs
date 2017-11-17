#!/bin/bash

#########################################################################
# Purpose: Creates and populates GNRS database 
#
# Usage:	./gnrs_db.sh
#
# Warning: Requires database geonames on local filesystem
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 12 June 2017
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

######################################################
# Set basic parameters, functions and options
######################################################

# Get local working directory
DIR_LOCAL="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR_LOCAL" ]]; then DIR_LOCAL="$PWD"; fi

# $local = name of this file
# $local_basename = name of this file minus '.sh' extension
# $local_basename should be same as containing directory, as  
# well as local data subdirectory within main data directory, 
local=`basename "${BASH_SOURCE[0]}"`
local_basename="${local/.sh/}"

# Set parent directory if running independently
if [ -z ${master+x} ]; then
	DIR=$DIR_LOCAL
fi

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

# Pseudo error log, to absorb screen echo during import
tmplog="/tmp/tmplog.txt"
echo "Error log
" > $tmplog

# Set current script as master if not already source by another file
# master = name of this file. 
# Tells sourced scripts not to reload general parameters and command line 
# options as they are being called by another script. Allows component 
# scripts to be called individually if needed
if [ -z ${master+x} ]; then
	master=`basename "$0"`
fi

#########################################################################
# Main
#########################################################################
: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

############################################
# Load raw data to table user_data
############################################

echoi $e -n "- Dropping indexes on user_data..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/core_tables_drop_indexes.sql
source "$DIR/includes/check_status.sh" 

# This deletes any existing data in table user_data
# Assume user_data_raw has been populated
echoi $e -n "- Loading user_data..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v tbl_raw=$tbl_raw -f $DIR_LOCAL/sql/load_user_data.sql
source "$DIR/includes/check_status.sh" 

############################################
# Check against existing results in cache
############################################

echoi $e -n "- Checking existing results in cach..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/check_cache.sql
source "$DIR/includes/check_status.sh" 

#echo "EXITING!!!"; exit 0

############################################
# Resolve Political divisions
############################################

echoi $e "Country:"

echoi $e -n "- exact..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/resolve_country_exact.sql
source "$DIR/includes/check_status.sh" 

echoi $e -n "- fuzzy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$match_threshold -f $DIR_LOCAL/sql/resolve_country_fuzzy.sql
source "$DIR/includes/check_status.sh" 

echoi $e "State/province:"

echoi $e -n "- exact..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/resolve_sp_exact.sql
source "$DIR/includes/check_status.sh" 

echoi $e -n "- fuzzy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$match_threshold -f $DIR_LOCAL/sql/resolve_sp_fuzzy.sql
source "$DIR/includes/check_status.sh" 

echoi $e "County/parish:"

echoi $e -n "- exact..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/resolve_cp_exact.sql
source "$DIR/includes/check_status.sh" 

echoi $e -n "- fuzzy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$match_threshold -f $DIR_LOCAL/sql/resolve_cp_fuzzy.sql
source "$DIR/includes/check_status.sh" 

############################################
# Summarize results
############################################

echoi $e -n "Summarizing results..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/summarize.sql
source "$DIR/includes/check_status.sh" 

############################################
# Updating cache
############################################

# Add new results to cache
echoi $e -n "- Updating cache..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/update_cache.sql
source "$DIR/includes/check_status.sh" 

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################