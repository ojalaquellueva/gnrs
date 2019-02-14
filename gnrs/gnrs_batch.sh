#!/bin/bash

#########################################################################
# Purpose: Creates and populates GNRS database 
#
# Usage:	./gnrs_db.sh [-s] [-f /absolute/path/inputfilename] [-m me@valid.notification_email]
#
# Warning: Requires database gnrs on local filesystem
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

# Set parent directory if running independently & suppress main message
if [ -z ${master+x} ]; then
	#DIR=$DIR_LOCAL"/.."
	DIR=$DIR_LOCAL
	suppress_main='true'
else
	suppress_main='false'
fi

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
custom_opts="true"
source "$DIR/../includes/startup_local.sh"	

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
# Get custom options
#   -s  Silent mode. Suppresses screen echo.
#   -m  Send email notification. Must supply valid email 
#               in params file.
###########################################################

# Set defaults
e="true"	# Echo/interactive mode on by default
f_custom="false"	# Use default input/output files and data directory
infile=$data_dir_local"/"$submitted_filename	# Default input file & path
outfile=$data_dir_local"/"$results_filename	# Default input file & path
mailme="false"

while [ "$1" != "" ]; do
    case $1 in
        -s | --silent )         e="false"
                            	;;
        -f | --infile )        	f_custom="true"
        						shift
                                infile=$1
                                ;;
        -m | --mailme )       	mailme="true"
        						shift
        						email=$1
                                ;;
        * )                     echo "invalid option!"; exit 1
    esac
    shift
done

# Check input file [and directory] exists
if [ "$f_custom" == "true" ] && [ "$infile" == "" ]; then	
    echo "Input file name missing!"; exit 1    	
fi
if [ ! -f "$infile" ]; then
    echo "Input file $infile does not exist!"; exit 1    
fi

# Set results file
data_dir=$(dirname "${infile}")
outfile_basename=$(basename ${infile%.*})
outfile=$data_dir"/"$outfile_basename"_gnrs_results.csv"

# Check valid email
if [[ "$mailme" == "true" ]]; then
	if ! checkemail "$email"; then
		echo "ERROR: invalid email"; exit 1
	fi
else
	email="n/a"
fi

#########################################################################
# Main
#########################################################################
: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

############################################
# Confirmation message
############################################


if [ "$e" = "true" ]; then
        echo "Execute GNRS batch with the following settings?

        infile: 	$infile
        Results file: 	$outfile
        Notify: 	$mailme
        Notify email:	$email
        "
        read -p "Continue? (Y/N): " -r
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
                continue="true"
        else 
                echo "Operation cancelled"; exit 0
        fi
fi

############################################
# Import raw data 
#
# Import CSV file from data directory to 
# table user_data_raw in GNRS database
############################################

echoi $e "Importing user data:"

echoi $e -n "- Clearing raw table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -c 'TRUNCATE user_data_raw'
source "$DIR/../includes/check_status.sh"  

# Data
datafile=$data_raw

echoi $e "- Importing raw data:"
echoi $i -n "-- '$submitted_filename' --> user_data_raw..."

#use_limit='false'	# For testing
if [ $use_limit = "true" ]; then 
	# Import subset of records (development only)
	#head -n $recordlimit $data_dir_local/$submitted_filename | psql -U $user $db_gnrs -q -c "COPY user_data_raw FROM STDIN DELIMITER ',' CSV NULL AS 'NA' HEADER"
	head -n $recordlimit $infile | psql -U $user $db_gnrs -q -c "COPY user_data_raw FROM STDIN DELIMITER ',' CSV NULL AS 'NA' HEADER"
else
	# Import full file
	#sql="\COPY user_data_raw FROM '${data_dir_local}/${submitted_filename}' DELIMITER ',' CSV NULL AS 'NA' HEADER;"
	sql="\COPY user_data_raw FROM '${infile}' DELIMITER ',' CSV NULL AS 'NA' HEADER;"
	PGOPTIONS='--client-min-messages=warning' psql -U $user $db_gnrs -q << EOF
	\set ON_ERROR_STOP on
	$sql
EOF
fi
source "$DIR/../includes/check_status.sh"

############################################
# Insert raw data into table user_data and
# process with GNRS
############################################

# Run the main GNRS app
source "$DIR/gnrs.sh"

############################################
# Export results from user_data to data 
# directory sa CSV file
############################################

echoi $e -n "Exporting CSV file of results to data directory..."
#gnrs_results_file=$data_dir_local"/"$results_filename
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs -q << EOF
\set ON_ERROR_STOP on
\copy user_data TO '${outfile}' csv header
EOF
echoi $i "done"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/../includes/finish.sh"; fi

######################################################
# End script
######################################################