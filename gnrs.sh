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

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Other temporary code to be executed before comment block
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
## Temporary code to be executed after comment block
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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
threshold=$DEF_MATCH_THRESHOLD	# Use default (from params.sh)
threshold_type="default"

while [ "$1" != "" ]; do
    case $1 in
        -a | --api )         	api="true"
                            	;;
        -t | --threshold )     	shift
        						threshold=$1
        						threshold_type="custom"
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

# Check fuzzy match threshold set correctly
if [[ $threshold =~ ^[+-]?[0-9]+$ ]] || [[ $threshold =~ ^[+-]?[0-9]*\.?[0-9]+$ ]]; then
	# Value is integer or float; check in range [0:1]
	if [ $(echo "($threshold < 0) || ($threshold > 1)" | bc -l) -eq 1 ]; then
		echo "ERROR: Match threshold not in range [0:1]"; exit 1
	fi 
else
	echo "ERROR: Match threshold not a number"; exit 1
fi

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

# Detect political division submitted
# Flag bad records to omit from further processing 
echoi $e -n "- Flagging political divisions submitted..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/detect_poldiv_submitted.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

# Populate alternate verbatim state and county columns
# Values are stripped of admin category identifiers such as "State",
# "Department", "Municipio de", etc.
echoi $e -n "- Populating alt state_province_verbatim column..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/populate_sp_verbatim_alt.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

# Populate alternate verbatim state and county columns
# Values are stripped of admin category identifiers such as "State",
# "Department", "Municipio de", etc.
echoi $e -n "- Populating alt county_parish_verbatim_verbatim column..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/populate_cp_verbatim_alt.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

############################################
# Check against existing results in cache
############################################

# Start by assuming all records not in cache
not_cached="t"
if [ "$threshold_type" == "default" ]; then
	# Only check cache if using default match threshold
	echoi $e -n "Checking for existing results in cache..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/check_cache.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	# If all records already in cache, skip resolution
	sql_not_cached="SELECT EXISTS ( SELECT id FROM user_data WHERE job='$job' AND match_status IS NULL) AS a"
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs -qt -c \"$sql_not_cached\" | tr -d '[[:space:]]'"
	not_cached=$(eval "$cmd")
fi

######## For testing only ########
if [ "$debug_mode" == "t" ]; then
	curruser=$(whoami)
# 	if [ "$curruser" == "www-data" ]; then
# 		zz_dir="/tmp/gnrs"
# 	else
# 		zz_dir="../data/user"
# 	fi
	zz_dir=$data_dir_local_abs

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
	# Process non-cached records

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
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$threshold -v job=$job -f $DIR_LOCAL/sql/resolve_country_fuzzy.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e "- Country-as-state:"
	echoi $e -n "-- exact..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/resolve_countryasstate_exact.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job  -v match_threshold=$threshold -f $DIR_LOCAL/sql/resolve_countryasstate_fuzzy.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e "- State/province:"
	echoi $e -n "-- exact..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/resolve_sp_exact.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$threshold -v job=$job -f $DIR_LOCAL/sql/resolve_sp_fuzzy.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e "- State-as-country:"

	echoi $e -n "-- exact..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/resolve_stateascountry_exact.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job  -v match_threshold=$threshold -f $DIR_LOCAL/sql/resolve_stateascountry_fuzzy.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e "- County/parish:"
	echoi $e -n "-- exact..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/resolve_cp_exact.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v match_threshold=$threshold -v job=$job -f $DIR_LOCAL/sql/resolve_cp_fuzzy.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e "- State-as-county:"
	echoi $e -n "-- exact..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/resolve_stateascounty_exact.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job  -v match_threshold=$threshold -f $DIR_LOCAL/sql/resolve_stateascounty_fuzzy.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e "- County-as-state:"
	echoi $e -n "-- exact..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/resolve_countyasstate_exact.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "-- fuzzy..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job  -v match_threshold=$threshold -f $DIR_LOCAL/sql/resolve_countyasstate_fuzzy.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

	echoi $e -n "- Summarizing results..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/summarize.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 

else
	# Nothing to process, all submitted values already in cache
	echoi $e "- All submitted political divisions already in cache!"
fi

############################################
# Populate supplementary fields
############################################

echoi $e -n "Populating ISO codes..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/iso_codes.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

echoi $e -n "Populating gadm IDs..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/gadm_ids.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

echoi $e -n "Populating geonames IDs..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/geonames_ids.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

echoi $e -n "Updating match scores..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/update_match_scores.sql"
eval $cmd
source "$DIR/includes/check_status.sh" 

############################################
# Updating cache
############################################

# Add new results to cache
# Only do if use default match threshold
if [ "$threshold_type" == "default" ]; then
	echoi $e -n "Updating cache..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/update_cache.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh" 
fi

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