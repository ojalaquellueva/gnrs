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

# Default outputfile suffix
# If $outfile not supplied by user, output file name will be formed by
# appending this suffix to basename of input file
outfile_suffix="_gnrs_results"

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
i="true"	# Interactive mode on by default
f_custom="false"	# Use default input/output files and data directory
api="false"		# Assume not an api call
infile=""
outfile=""
delim=","		# Output file delimiter; default=csv
mailme="false"
header="true"	# Assume input file has header

while [ "$1" != "" ]; do
    case $1 in
        -s | --silent )         e="false"
        						i="false"
                            	;;
        -a | --api )        api="true"
                            	;;
        -n | --noheader )       header="false"
                            	;;
        -f | --infile )        	f_custom="true"
        						shift
                                infile=$1
                                ;;
        -o | --outfile )       	shift
                                outfile=$1
                                ;;
        -d | --delim )      	shift
                                delim=$1
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

# Set header option for file import
opt_header="HEADER"
if  [ "$header" == "false" ]; then
	opt_header=""
fi

# Set delimiter option for file export
# Default option is CSV
opt_delim=""
delim_disp="CSV"
if  [ "$delim" == "t" ]; then
	opt_delim="DELIMITER E'\t'"
	delim_disp="TSV"
fi

# Set results file
# data_dir=$(dirname "${infile}")
# outfile_basename=$(basename ${infile%.*})
# outfile=$data_dir"/"$outfile_basename"_gnrs_results.csv"

# Output file path and name
if [[ ! "$outfile" == "" ]]; then
	# Check destination directory exists
	outdir=$(dirname "${outfile}")
	if [ ! -d "$outdir" ]; then
		echo "ERROR in outfile '$outfile': no such path"
		exit 1
	fi
else
	# Create default results file path and name
	outdir=$(dirname "${infile}")
	filename=$(basename -- "${infile}")
	ext="${filename##*.}"
	base="${filename%.*}"
	outfilename="${base}${outfile_suffix}.${ext}"
	outfile="${outdir}/${outfilename}"
fi

# Set PGPASSWORD for api access
# Parameter $pgpwd set in config file
# Not needed if not an api call
opt_pgpassword=""
opt_user="-U $user"
if  [ "$api" == "true" ]; then
	opt_pgpassword="PGPASSWORD=$pgpwd"
	opt_user="-U $user"
	
	# Turn off all echoes, regardless of echo options sent
	e="false"
	i="false"
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

if [ "$i" = "true" ]; then
        echo "Execute GNRS batch with the following settings?

        Database: 	$db_gnrs
        Input file: 	$infile
        Has header:	$header
        Output file: 	$outfile
        Output file delimiter: $delim_disp
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
	
	echoi $e -n "Clearing all user_data..."
	cmd="$opt_pgpassword PGOPTIONS='--client-min-messages=warning' psql $opt_user -d $db_gnrs --set ON_ERROR_STOP=1 -q -c 'DELETE FROM user_data'"
	eval $cmd
	echoi $e "done"

	echoi $e -n "Clearing entire cache..."
	cmd="$opt_pgpassword PGOPTIONS='--client-min-messages=warning' psql $opt_user -d $db_gnrs --set ON_ERROR_STOP=1 -q -c 'DELETE FROM cache'"
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
cmd="$opt_pgpassword PGOPTIONS='--client-min-messages=warning' psql $opt_user -d $db_gnrs --set ON_ERROR_STOP=1 -q -c 'DELETE FROM user_data_raw' WHERE job='$job'"
eval $cmd
source "$DIR/includes/check_status.sh"  

echoi $e "- Importing raw data:"

# Compose name of temporary, job-specific raw data table
raw_data_tbl_temp="user_data_raw_${job}"

# Create job-specific temp table to hold raw data
echoi $e -n "-- Creating temp table $raw_data_tbl_temp..."
cmd="$opt_pgpassword PGOPTIONS='--client-min-messages=warning' psql $opt_user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -v raw_data_tbl_temp=\"${raw_data_tbl_temp}\" -f $DIR_LOCAL/sql/create_raw_data_temp.sql"
eval $cmd
source "$DIR/includes/check_status.sh"

# Import the raw data
# Note "NULL AS NA": concession to R users
# Will make this a parameter at some point, with NULL AS NA as the default
echoi $e -n "-- Importing '$submitted_filename' to temp table..."
metacmd="\COPY $raw_data_tbl_temp FROM '${infile}' DELIMITER ',' CSV NULL AS 'NA' ${opt_header};"
cmd="$opt_pgpassword PGOPTIONS='--client-min-messages=warning' psql $opt_user $db_gnrs --set ON_ERROR_STOP=1 -q -c \"${metacmd}\""
eval $cmd
source "$DIR/includes/check_status.sh"

# Import the raw data
echoi $e -n "-- Inserting from temp table to user_data_raw..."
cmd="$opt_pgpassword PGOPTIONS='--client-min-messages=warning' psql $opt_user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -v raw_data_tbl_temp=\"${raw_data_tbl_temp}\" -f $DIR_LOCAL/sql/import_user_data.sql"
eval $cmd
source "$DIR/includes/check_status.sh"

############################################
# Insert raw data into table user_data and
# process with GNRS
############################################

# Run the main GNRS app
if  [ "$api" == "true" ]; then
	# API call (use password) also turn off echo
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
sql="\copy (SELECT poldiv_full, country_verbatim, state_province_verbatim, state_province_verbatim_alt, county_parish_verbatim, county_parish_verbatim_alt, country, state_province, county_parish, country_id, state_province_id, county_parish_id, country_iso, state_province_iso, county_parish_iso, geonameid, gid_0, gid_1, gid_2, match_method_country, match_method_state_province, match_method_county_parish, match_score_country, match_score_state_province, match_score_county_parish, poldiv_submitted, poldiv_matched, match_status, user_id FROM user_data WHERE job='$job') TO '$outfile' csv header $opt_delim"
cmd="$opt_pgpassword PGOPTIONS='--client-min-messages=warning' psql $opt_user -d $db_gnrs --set ON_ERROR_STOP=1 -q -c \"$sql\""
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

if [ "$debug_mode" == "t" ]; then
	echoi $e -n "Clearing user data for this job from database..."
	cmd="$opt_pgpassword PGOPTIONS='--client-min-messages=warning' psql $opt_user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v job=$job -f $DIR_LOCAL/sql/clear_user_data.sql"
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