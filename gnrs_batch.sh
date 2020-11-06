#!/bin/bash

#########################################################################
# GNRS batch application 
#  
# Purpose: Submits file of political division names to GNRS core service  
#	and saves results to same directory as input file.
#
# Usage:
#	./gnrs_db.sh [-s] [-f /absolute/path/inputfilename] [-m me@valid.notification_email]
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# Set basic parameters, functions and options
######################################################

# Assign job unique ID
# Date in nanoseconds plus random integer for good measure
job="job_$(date +%Y%m%d_%H%M%N)_${RANDOM}"	

# The name of this file. Tells sourced scripts not to reload general  
# parameters and command line options as they are being called by  
# another script. Allows component scripts to be called individually  
# if needed
master=`basename "$0"`

# Get working directory
DIR="${BASH_SOURCE%/*}"
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

pname="GNRS Batch"

###########################################################
# Get custom options
#   -s  Silent mode. Suppresses screen echo.
#   -m  Send email notification. Must supply valid email 
#               in params file.
###########################################################

# back up existing value of $e
if [ -z ${e+x} ]; then
	e_bak=$e
fi

# Set defaults
e="true"	# Echo/interactive mode on by default
f_custom="false"	# Use default input/output files and data directory
api="false"		# Assume not an api call
infile=$data_dir_local"/"$submitted_filename	# Default input file & path
outfile=$data_dir_local"/"$results_filename	# Default input file & path
mailme="false"

while [ "$1" != "" ]; do
    case $1 in
        -s | --silent )         e="false"
                            	;;
        -a | --api )        api="true"
                            	;;
        -f | --infile )        	f_custom="true"
        						shift
                                infile=$1
                                ;;
        -m | --mailme )       	mailme="true"
        						shift
        						email=$1
                                ;;
        * )                     echo "invalid option: $1 ($local)"; exit 1
    esac
    shift
done

# Check input file [and directory] exists
if [ "$f_custom" == "true" ] && [ "$infile" == "" ]; then	
    echo "Input file name missing!"; exit 1    	
fi
if [ ! -f "$infile" ]; then
    echo "Input file '$infile' does not exist!"; exit 1    
fi

# Set results file
data_dir=$(dirname "${infile}")
outfile_basename=$(basename ${infile%.*})
outfile=$data_dir"/"$outfile_basename"_gnrs_results.csv"

# Set PGPASSWORD for api access
# Parameter $pgpwd set in config file
# Not needed if not an api call
pgpassword=""
if  [ "$api" == "true" ]; then
	pgpassword="PGPASSWORD=$pgpwd"
fi

# Check valid email
if [[ "$mailme" == "true" ]]; then
	if ! checkemail "$email"; then
		echo "ERROR: invalid email"; exit 1
	fi
else
	email="n/a"
fi

############################################
# Confirmation message
############################################

if [ "$e" = "true" ]; then
        echo "Execute GNRS batch with the following settings?

        infile: 	$infile
        Results file: 	$outfile
        Notify: 	$mailme
        Notify email:	$email
        Job id:		$job
        "
        read -p "Continue? (Y/N): " -r
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
                continue="true"

        else 
                echo "Operation cancelled"; exit 0
        fi
fi

# Start the time
source "$includes_dir/start_time.sh"

# Start time, send mail if requested and echo begin message
# Start timing & process ID
starttime="$(date)"
start=`date +%s%N`; prev=$start
pid=$$

if [[ "$m" == "true" ]]; then 
	source "${includes_dir}/mail_process_start.sh"	# Email notification
fi

if [ "$e" == "true" ]; then
	echoi $e ""; echoi $e "------ Process $pname started at $starttime ------"
	echoi $e ""
fi


#########################################################################
# Main
#########################################################################


####### For testing only #######
if [ "$debug_mode" == "t" ]; then
	# Clear everything, cache & user data
	
	echoi $e -n "Clearing user_data..."
	# This should be default
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -c 'DELETE FROM user_data'"
	eval $cmd
	echoi $e "done"

	echoi $e -n "Clearing cache..."
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -c 'DELETE FROM cache'"
	eval $cmd
	echoi $e "done"
fi
####### END For testing only #######

############################################
# Import raw data 
#
# Import CSV file from data directory to 
# table user_data_raw in GNRS database
############################################

echoi $e "Importing user data:"

echoi $e -n "- Clearing table user_data_raw..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -c 'DELETE FROM user_data_raw' WHERE job='$job'"
eval $cmd
source "$DIR/includes/check_status.sh"  

echoi $e "- Importing raw data:"

: <<'COMMENT_BLOCK_1'
# The development limit/testing option below need to be updated
# to accommodate use of job # with all raw data
if [ $use_limit = "true" ]; then 
	# Import subset of records (development only)
	head -n $recordlimit $infile | psql -U $user $db_gnrs -q -c "COPY user_data_raw FROM STDIN DELIMITER ',' CSV NULL AS 'NA' HEADER"
else
	# Import full file
 	sql="\COPY user_data_raw FROM '${infile}' DELIMITER ',' CSV NULL AS 'NA' HEADER;"
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user $db_gnrs --set ON_ERROR_STOP=1 -q -c \"${sql}\""
	eval $cmd
fi
COMMENT_BLOCK_1

# Compose name of temporary, job-specific raw data table
raw_data_tbl_temp="user_data_raw_${job}"

# Create job-specific temp table to hold raw data
echoi $e -n "-- Creating temp table $raw_data_tbl_temp..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -v raw_data_tbl_temp=\"${raw_data_tbl_temp}\" -f $DIR_LOCAL/sql/create_raw_data_temp.sql"
eval $cmd
source "$DIR/includes/check_status.sh"

# Import the raw data
# Not "NULL AS NA": concession to R users
# Will make this a parameter at some point, with NULL AS NA as the default
echoi $e -n "-- Importing '$submitted_filename' to temp table..."
metacmd="\COPY $raw_data_tbl_temp FROM '${infile}' DELIMITER ',' CSV NULL AS 'NA' HEADER;"
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user $db_gnrs --set ON_ERROR_STOP=1 -q -c \"${metacmd}\""
eval $cmd
source "$DIR/includes/check_status.sh"

# Import the raw data
echoi $e -n "-- Inserting from temp table to user_data_raw..."
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -v raw_data_tbl_temp=\"${raw_data_tbl_temp}\" -f $DIR_LOCAL/sql/import_user_data.sql"
eval $cmd
source "$DIR/includes/check_status.sh"

############################################
# Insert raw data into table user_data and
# process with GNRS
############################################

# Run the main GNRS app
if  [ "$api" == "true" ]; then
	# API call (use password) also turn off echo & send job#
	$DIR/gnrs.sh -a -s -j $job
else
	if [ "$e" == "false" ]; then
		$DIR/gnrs.sh -s -j $job
	else
		$DIR/gnrs.sh -j $job
	fi
fi

############################################
# Export results from user_data to data 
# directory sa CSV file
############################################

echoi $e -n "Exporting CSV file of results to data directory..."
# "set -f" turns off globbing to prevent expansion of asterisk to unix wildcard
set -f
sql="\copy (SELECT * FROM user_data WHERE job='$job') TO '$outfile' csv header"
cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -c \"$sql\""
eval $cmd
set +f
source "$DIR/includes/check_status.sh"

####### For testing only #######
if [ "$debug_mode" == "t" ]; then
	curruser=$(whoami)
	if [ "$curruser" == "www-data" ]; then
		# Write current options to file, for testing only
		currdatadir="/tmp/gnrs"
	else
		currdatadir="../data/user"
	fi

	echo "current user: $curruser ($local)" > $currdatadir/zz_gnrs_batch_options.txt
	echo "api: $api" > $currdatadir/zz_gnrs_batch_options.txt
	echo "sql: $sql" >> $currdatadir/zz_gnrs_batch_options.txt
	echo "cmd: $cmd" >> $currdatadir/zz_gnrs_batch_options.txt
	echo "db user: $user" >> $currdatadir/zz_gnrs_batch_options.txt
	echo "db: $db_gnrs" >> $currdatadir/zz_gnrs_batch_options.txt
	#echo ""; echo "Stopping after \copy command"; exit 0
fi
####### END: For testing only #######

############################################
# Clear user data tables
############################################

echoi $e -n "Clearing user data for this job from database..."
if [ "$debug_mode" == "t" ]; then
	# Keeping user data (for testing only)
	echoi $e "skipping (debug_mode=='t')"
else
	# This should be default
	cmd="$pgpassword PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/clear_user_data.sql"
	eval $cmd
	source "$DIR/includes/check_status.sh"
fi

######################################################
# Report total elapsed time if running solo
######################################################

# Restore previous value of $e, if applicable
if [ -z ${e_bak+x} ]; then
	e=$e_bak
fi

if [ master==`basename "$0"` ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################