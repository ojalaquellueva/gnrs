#!/bin/bash

#########################################################################
# Purpose: Imports user data for processing with gnrs
#
# Usage:	./gnrs_import.sh
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

# Assign unique job ID
# Date in nanoseconds plus random integer for good measure
job="job_$(date +%Y%m%d_%H%M%N)_${RANDOM}"	

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
#if [ -z ${master+x} ]; then
	DIR=$DIR_LOCAL
#fi

# Set includes directory path, relative to $DIR
includes_dir=$DIR"/includes"

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
custom_opts="true"
source "$includes_dir/startup_local.sh"	

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

###########################################################
# Get and set custom parameters
###########################################################

# Set defaults
nullval=""

while [ "$1" != "" ]; do
    case $1 in
        -s | --silent )         silent="true"
                            	;;
        -n | --nowarnings )		i="false"
        						;;
        -v | --nullval )        shift
        						nullval="$1"
                            	;;
        * )                     echo "invalid option!"; exit 1
    esac
    shift
done

# Set final value of "NULL AS '<nullval>'"
# Note that omitting this parameter removes this component
# completely from \copy command
if  [ "nullval" == "" ]; then
	nullas=""
else
	nullas="NULL AS '"$nullval"'"
fi

#########################################################################
# Main
#########################################################################
: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

############################################
# Import raw data 
#
# Import CSV file from data directory to 
# table user_data_raw in GNRS database
############################################

echoi $e "Importing user data:"

echoi $e -n "- Clearing raw table..."
PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -c "DELETE FROM user_data_raw WHERE job='$job'"
source "$includes_dir/check_status.sh"  

# Data
datafile=$data_raw

echoi $e "- Importing raw data:"
echoi $e "-- '$submitted_filename' --> user_data_raw"

: <<'COMMENT_BLOCK_1'
# The development limit option below need to be updated
# to accommodate use of job # with raw import

# Import the raw data
# Value of $nullas statement set as optional command line parameter
if [ $use_limit = "true" ]; then 
	# Import subset of records (development only)
	head -n $recordlimit $data_dir_local/$submitted_filename | psql -d gnrs -q -c "COPY user_data_raw FROM STDIN DELIMITER ',' CSV $nullas HEADER"
else
	# Import full file
	sql="\COPY user_data_raw FROM '${data_dir_local}/${submitted_filename}' DELIMITER ',' CSV $nullas HEADER;"
	PGOPTIONS='--client-min-messages=warning' psql -d gnrs -q << EOF
	\set ON_ERROR_STOP on
	$sql
EOF
fi
source "$includes_dir/check_status.sh"

COMMENT_BLOCK_1

# Compose name of temporary, job-specific raw data table
raw_data_tbl_temp="user_data_raw_${job}"

# Create job-specific temp table to hold raw data
echoi $e -n "-- Creating table $raw_data_tbl_temp..."
PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -v raw_data_tbl_temp="${raw_data_tbl_temp}" -f $DIR_LOCAL/sql/create_raw_data_temp.sql
source "$DIR/includes/check_status.sh"

# Import the raw data
# $nullas statement set as optional command line parameter
echoi $e -n "-- Importing raw data to temp table..."
metacmd="\COPY $raw_data_tbl_temp FROM '${data_dir_local}/${submitted_filename}'  DELIMITER ',' CSV $nullas  HEADER;"
PGOPTIONS='--client-min-messages=warning' psql gnrs --set ON_ERROR_STOP=1 -q -c "$metacmd"
eval $cmd
source "$DIR/includes/check_status.sh"

# Import the raw data
echoi $e -n "-- Loading to raw data table with job..."
PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -v raw_data_tbl_temp="$raw_data_tbl_temp" -f $DIR_LOCAL/sql/import_user_data.sql
eval $cmd
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$includes_dir/finish.sh"; fi

######################################################
# End script
######################################################