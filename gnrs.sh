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

# Get working directory
DIR="$(dirname ${BASH_SOURCE[0]})"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Start logfile
export glogfile="$DIR/log/logfile_"$master".txt"
mkdir -p "$DIR/log" 
touch $glogfile

# Set includes directory path, relative to $DIR
includes_dir=$DIR"/includes"

# Load parameters file
source "$DIR/params.sh"

# Load db configuration params
source "$db_config_path/db_config.sh"	

# Load functions 
source "$includes_dir/functions.sh"

# Set local directories to same as main
data_dir_local=$data_base_dir
data_dir=$data_base_dir
DIR_LOCAL=$DIR

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

# back up existing value of $e
if [ ! -z ${e+x} ]; then
	e_bak=$e
fi

# Set defaults
api="false"		# Assume not an api call
pgpassword=""	# Not needed if not an api call
silent="false"	# Assume echo & interactive are on

while [ "$1" != "" ]; do
    case $1 in
        -a | --api )         	api="true"
                            	;;
        -s | --silent )         silent="true"
                            	;;
        -j | --job )        	shift
                                job=$1
                                ;;
         * )                     echo "invalid option: $1 ($local)"; exit 1
    esac
    shift
done

# Set PGPASSWORD for api access
# Parameter $pgpwd set in config file
if  [ "$api" == "true" ]; then
	pgpassword="PGPASSWORD=$pgpwd"
fi

# Set echo parameter, if applicable
if [ "$silent" == "true" ]; then
	e="false"
else
	e="true"
fi

# Start timer if previous time not sent by calling script
if  [ master=`basename "$0"` ]; then
	source "$includes_dir/start_time.sh"
else 
	prev=`date +%s%N`
fi

#########################################################################
# Main
#########################################################################

############################################
# Load raw data to table user_data
############################################

echoi $e -n "- Dropping indexes on table user_data..."
#PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -f "$DIR_LOCAL/sql/drop_indexes_user_data.sql"
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/drop_indexes_user_data.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

# This deletes any existing data in table user_data
# Assume user_data_raw has been populated
echoi $e -n "- Loading table user_data..."
#PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f "$DIR_LOCAL/sql/load_user_data.sql"
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/load_user_data.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

############################################
# Check against existing results in cache
############################################

###### Testing only! ######
if [ "$debug_mode" == "t" ]; then
	# Test user's DB authorization by inserting test records to table user_data
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/test2_load_user_data.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 
fi
###### END Testing only! ######

echoi $e -n "Checking for existing results in cache..."
#PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f "$DIR_LOCAL/sql/check_cache.sql"
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/check_cache.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

# If all records already in cache, skip resolution
sql_not_cached="SELECT EXISTS ( SELECT id FROM user_data WHERE job='$job' AND match_status IS NULL) AS a"
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs -qt -c \"$sql_not_cached\" | tr -d '[[:space:]]'"
not_cached=$(eval "$cmd")

######## For testing only ########
if [ "$debug_mode" == "t" ]; then
	curruser=$(whoami)
	if [ "$curruser" == "www-data" ]; then
		zz_dir="/tmp/gnrs"
	else
		zz_dir="../data/user"
	fi

	echo "Current user: $curruser ($local)" > $zz_dir/zz_gnrs_options.txt
	echo "e: $e" >> $zz_dir/zz_gnrs_options.txt
	echo "silent: $silent" >> $zz_dir/zz_gnrs_options.txt
	echo "api: $api" >> $zz_dir/zz_gnrs_options.txt
	echo "DB: $db_gnrs" >> $zz_dir/zz_gnrs_options.txt
	echo "DB user: $user" >> $zz_dir/zz_gnrs_options.txt
	echo "pgpassword: $pgpassword" >> $zz_dir/zz_gnrs_options.txt
	echo "sql_not_cached: $sql_not_cached" >> $zz_dir/zz_gnrs_options.txt
	echo "cmd: $cmd" >> $zz_dir/zz_gnrs_options.txt
	echo "not_cached: $not_cached" >> $zz_dir/zz_gnrs_options.txt
	echo "job: $job" >> $zz_dir/zz_gnrs_options.txt
fi
######## END: For testing only ########

if [ "$not_cached" == "t" ]; then 
	############################################
	# Resolve political divisions & summarize
	############################################

	echoi $e "Resolving political divisions:"

	echoi $e "- Country:"
	echoi $e -n "-- exact..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/resolve_country_exact.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$match_threshold -v job=$job -f $DIR_LOCAL/sql/resolve_country_fuzzy.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e "- State/province:"
	echoi $e -n "-- exact..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/resolve_sp_exact.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$match_threshold -v job=$job -f $DIR_LOCAL/sql/resolve_sp_fuzzy.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e "- County/parish:"
	echoi $e -n "-- exact..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/resolve_cp_exact.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$match_threshold -v job=$job -f $DIR_LOCAL/sql/resolve_cp_fuzzy.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "- Summarizing results..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/summarize.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

else
	echoi $e "- All submitted political divisions already in cache!"
fi

############################################
# Populate ISO codes (add-on feature)
############################################

echoi $e -n "Populating ISO codes..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/iso_codes.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

############################################
# Updating cache
############################################

# Add new results to cache
echoi $e -n "Updating cache..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/update_cache.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

######################################################
# Report total elapsed time and exit if running solo
######################################################

# Restore previous value of $e, if applicable
if [ ! -z ${e_bak+x} ]; then
	e=$e_bak
fi

######################################################
# End script
######################################################