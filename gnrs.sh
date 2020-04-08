#!/bin/bash

#########################################################################
# GNRS core application
#  
# Purpose: Standardizes spellings of political division names to 
#	geonames.org 
#
# Usage:	./gnrs.sh
#
# Requires: 
# 	1. GNRS database (create separately with module gnrs_db.sh)
#	2. Input data already present in GNRS database. Reads input  
# 	from table observation and updates results to this same table.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# Set basic parameters, functions and options
######################################################

# Get local working directory
#DIR_LOCAL="${BASH_SOURCE%/*}"
DIR_LOCAL="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
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
if [[ -z ${DIR+x} ]]; then DIR="$PWD"; fi

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
custom_opts="true"
source "$DIR/includes/startup_local.sh"	

# Pseudo error log, to absorb screen echo during import
# tmplog="/tmp/tmplog.txt"
# echo "Error log
# " > $tmplog

# Set current script as master if not already source by another file
# master = name of this file. 
# Tells sourced scripts not to reload general parameters and command line 
# options as they are being called by another script. Allows component 
# scripts to be called individually if needed
if [ -z ${master+x} ]; then
	master=`basename "$0"`
fi

###########################################################
# Get custom options
#   -a	api call=true
###########################################################

# Set defaults
api="false"		# Assume not an api call
pgpassword=""	# Not needed if not an api call

while [ "$1" != "" ]; do
    case $1 in
        -a | --api )         	api="true"
                            	;;
        -s | --silent )         silent="true"
                            	;;
        -j | --job )        	shift
                                job=$1
                                ;;
         * )                     echo "invalid option!"; exit 1
    esac
    shift
done

# Set PGPASSWORD for api access
# Parameter $pgpwd set in config file
if  [ "$api" == "true" ]; then
	pgpassword="PGPASSWORD=$pgpwd"
	
	# Only set remaining options if api=true
	# Hence no defaults above
	if [ "$silent" == "true" ]; then
		e="false"
	else
		e="true"
	fi
fi

#########################################################################
# Main
#########################################################################

############################################
# Load raw data to table user_data
############################################

echoi $e -n "- Dropping indexes on table user_data..."
PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -f "$DIR_LOCAL/sql/drop_indexes_user_data.sql"
source "$DIR/includes/check_status.sh" 

# This deletes any existing data in table user_data
# Assume user_data_raw has been populated
echoi $e -n "- Loading table user_data..."
PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f "$DIR_LOCAL/sql/load_user_data.sql"
source "$DIR/includes/check_status.sh" 

############################################
# Check against existing results in cache
############################################

echoi $e -n "Checking for existing results in cache..."
PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f "$DIR_LOCAL/sql/check_cache.sql"
source "$DIR/includes/check_status.sh" 

# If all records already in cache, skip resolution
sql_not_cached="SELECT EXISTS ( SELECT id FROM user_data WHERE job='$job' AND match_status IS NULL) AS a"
not_cached=`psql -d gnrs -qt -c "$sql_not_cached" | tr -d '[[:space:]]'`

if [ "$not_cached" == "t" ]; then 
	############################################
	# Resolve political divisions & summarize
	############################################

	echoi $e "Resolving political divisions:"

	echoi $e "- Country:"
	echoi $e -n "-- exact..."
	PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f "$DIR_LOCAL/sql/resolve_country_exact.sql"
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$match_threshold -v job=$job -f "$DIR_LOCAL/sql/resolve_country_fuzzy.sql"
	source "$DIR/includes/check_status.sh" 

	echoi $e "- State/province:"
	echoi $e -n "-- exact..."
	PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f "$DIR_LOCAL/sql/resolve_sp_exact.sql"
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$match_threshold -v job=$job -f "$DIR_LOCAL/sql/resolve_sp_fuzzy.sql"
	source "$DIR/includes/check_status.sh" 

	echoi $e "- County/parish:"
	echoi $e -n "-- exact..."
	PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f "$DIR_LOCAL/sql/resolve_cp_exact.sql"
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$match_threshold -v job=$job -f "$DIR_LOCAL/sql/resolve_cp_fuzzy.sql"
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "- Summarizing results..."
	PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f "$DIR_LOCAL/sql/summarize.sql"
	source "$DIR/includes/check_status.sh" 

else
	echoi $e "- All political divisions already in cache!"
fi

############################################
# Populate ISO codes (add-on feature)
############################################

echoi $e -n "Populating ISO codes..."
PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f "$DIR_LOCAL/sql/iso_codes.sql"
source "$DIR/includes/check_status.sh" 

############################################
# Updating cache
############################################

# Add new results to cache
echoi $e -n "Updating cache..."
PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f "$DIR_LOCAL/sql/update_cache.sql"
source "$DIR/includes/check_status.sh" 

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################