#!/bin/bash

#########################################################################
# Purpose: Exports GNRS results 
#
# Usage:	./gnrs_export.sh
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

# Set includes directory path, relative to $DIR
includes_dir=$DIR"/includes"


# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
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

#########################################################################
# Main
#########################################################################
: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

############################################
# Export results from user_data to data 
# directory sa CSV file
############################################

echoi $e -n "Dumping gnrs results to data directory as file '$results_filename'..."
gnrs_results_file=$data_dir_local"/"$results_filename
rm "${gnrs_results_file}"
sql_results="SELECT * FROM user_data WHERE job='${job}' ORDER BY user_id, poldiv_full"
PGOPTIONS='--client-min-messages=warning' psql -d gnrs -q << EOF
\set ON_ERROR_STOP on
\copy '${sql_results}' TO '${gnrs_results_file}' csv header
EOF
echoi $i "done"

############################################
# Clear user data tables
############################################

echoi $e -n "Clearing user data for this job from database..."
PGOPTIONS='--client-min-messages=warning' psql -d gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/clear_user_data.sql
echoi $e "done"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/../includes/finish.sh"; fi

######################################################
# End script
######################################################