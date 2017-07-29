#!/bin/bash

#########################################################################
# Purpose: Creates and populates GNRS database 
#
# Usage:	sudo -u postgres ./gnrs_db.sh
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

# Psuedo error log, to absorb screen echo during import
echo "Error log
" > /tmp/tmplog.txt

#########################################################################
# Main
#########################################################################
: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1
############################################
# Create database in admin role & reassign
# to principal non-admin user of database
############################################

# Check if db already exists
# Warn to drop manually. This is safer.
if psql -lqt | cut -d \| -f 1 | grep -qw "$db_gnrs"; then
	# Reset confirmation message
	msg="Database '$db_gnrs' already exists! Please drop first."
	echo $msg; exit 1
fi

echoi $e -n "Creating database '$db_gnrs'..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "CREATE DATABASE $db_gnrs" 
source "$DIR/includes/check_status.sh"  

############################################
# Build gnrs tables in geonames database
############################################

echoi $e "Importing HASC code tables to geonames database:"




############################################
# Build gnrs tables in geonames database
############################################

echoi $e "Building political division tables in geonames database:"

echoi $e -n "- Country...."
PGOPTIONS='--client-min-messages=warning' psql -d geonames --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/country.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- State/province...."
PGOPTIONS='--client-min-messages=warning' psql -d geonames --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/state_province.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- County/parish..."
PGOPTIONS='--client-min-messages=warning' psql -d geonames --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/county_parish.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "Adjusting permissions for new tables..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -v db=$db_gnrs -v user_adm=$user -v user_read=$user_read -f $DIR_LOCAL/sql/set_permissions_geonames.sql
source "$DIR/includes/check_status.sh"	


############################################
# Import geonames tables
############################################

echoi $e "Copying tables from geonames db:"

# Dump table from source databse
echoi $e -n "- Creating dumpfile..."
dumpfile="/tmp/gnrs_geonames_extract.sql"
pg_dump -t country -t country_name -t state_province -t state_province_name -t county_parish -t county_parish_name 'geonames' > $dumpfile
source "$DIR/includes/check_status.sh"	

# Import table from dumpfile to target db & schema
echoi $e -n "- Importing tables from dumpfile..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 $db_gnrs < $dumpfile > /dev/null >> /tmp/tmplog.txt
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Removing dumpfile..."
rm $dumpfile
source "$DIR/includes/check_status.sh"	

echoi $e -n "Adjusting permissions..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -v db=$db_gnrs -v user_adm=$user -f $DIR_LOCAL/sql/set_permissions.sql
source "$DIR/includes/check_status.sh"	

: <<'COMMENT_BLOCK_2'
COMMENT_BLOCK_2
######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"