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

# Enable the following for strict debugging only:
#set -e

# The name of this file. Tells sourced scripts not to reload general  
# parameters and command line options as they are being called by  
# another script. Allows component scripts to be called individually  
# if needed
master=`basename "$0"`

# Get working directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Load parameters, functions and get command-line options
source "$DIR/includes/startup_master.sh"

# Confirm operation
source "$DIR/includes/confirm.sh"

# Set local directories to same as main
data_dir_local=$data_base_dir
DIR_LOCAL=$DIR

# Pseudo error log, to absorb screen echo during import
tmplog=$data_dir_local"/tmplog.txt"
echo "Error log
" > $tmplog

#########################################################################
# Main
#########################################################################
: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

############################################
# Import raw data 
############################################

echoi $e "Importing user data \"$src\":"

echoi $e -n "- Creating raw table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v tbl=$tbl_raw -f $DIR_LOCAL/sql/create_raw.sql
source "$DIR/includes/check_status.sh"  

# Data
datafile=$data_raw

echoi $e "- Importing raw data:"
echoi $i -n "-- '$datafile' --> $tbl..."

#use_limit='false'	# For testing
if [ $use_limit = "true" ]; then 
	# Import subset of records (development only)
	head -n $recordlimit $data_dir_local/$datafile | psql -U $user $db_gnrs -q -c "COPY ${dev_schema}.${tbl_raw} FROM STDIN DELIMITER ',' CSV NULL AS 'NA' HEADER"
else
	# Import full file
	sql="\COPY $tbl_raw FROM '${data_dir_local}/${datafile}' DELIMITER ',' CSV NULL AS 'NA' HEADER;"
	PGOPTIONS='--client-min-messages=warning' psql -U $user $db_gnrs -q << EOF
	\set ON_ERROR_STOP on
	$sql
EOF
fi
source "$DIR/includes/check_status.sh"

#echo "exiting..."; exit 0

echoi $e -n "- Altering table $tbl_raw..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v tbl=$tbl_raw -f $DIR_LOCAL/sql/alter_raw.sql
source "$DIR/includes/check_status.sh" 

echoi $e -n "- Creating table userdata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/create_user_data.sql
source "$DIR/includes/check_status.sh" 

echoi $e -n "- Loading userdata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v tbl_raw=$tbl_raw -f $DIR_LOCAL/sql/load_user_data.sql
source "$DIR/includes/check_status.sh" 

echoi $e -n "- Indexing userdata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/user_data_create_indexes.sql
source "$DIR/includes/check_status.sh" 

############################################
# Resolve Political divisiona
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


######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
