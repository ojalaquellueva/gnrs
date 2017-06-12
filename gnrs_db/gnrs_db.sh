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

#########################################################################
# Main
#########################################################################


############################################
# Create database in admin role & reassign
# to principal non-admin user of database
############################################

# Check if db already exists
if psql -lqt | cut -d \| -f 1 | grep -qw "$db_gnrs"; then
	# Reset confirmation message
	msg_conf="Replace existing database '$db_gnrs'?"
	confirm "$msg_conf"

	echoi $e -n "Dropping database '$db_gnrs'..."
	PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "DROP DATABASE $db_gnrs" 
	source "$DIR/includes/check_status.sh"  
fi

echoi $e -n "Creating database '$db_gnrs'..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "CREATE DATABASE $db_gnrs" 
source "$DIR/includes/check_status.sh"  

# Change owner to main user (bien)
echoi $e -n "Setting owner to '$user'..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "ALTER DATABASE $db_gnrs OWNER TO $user" 
source "$DIR/includes/check_status.sh" 

############################################
# Build gnrs tables in geonames database
############################################

echoi $e "Building tables in geonames database:"

echoi $e -n "- Country tables...."
PGOPTIONS='--client-min-messages=warning' psql -d geonames --set ON_ERROR_STOP=1 -q -f sql/country.sql
source "$DIR/includes/check_status.sh"

: <<'COMMENT_BLOCK_1'
echoi $e -n "- State/province tables...."
PGOPTIONS='--client-min-messages=warning' psql -d geonames --set ON_ERROR_STOP=1 -q -f sql/state_province.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- County/parish tables...."
PGOPTIONS='--client-min-messages=warning' psql -d geonames --set ON_ERROR_STOP=1 -q -f sql/county_parish.sql
source "$DIR/includes/check_status.sh"

############################################
# Import geonames tables
############################################

echoi $e "Copying tables from geonames db:"

# Dump table from source databse
echoi $e -n "- Creating dumpfile..."
dumpfile=$data_dir_local"/gnrs_geonames_extract.sql"
pg_dump -U $user -t countries -t state_province -t county_parish $db_geoscrub > $dumpfile
source "$DIR/includes/check_status.sh"	

# Drop the tables in gnrs database if already exist
echoi $e -n "- Dropping previous tables, if any..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -v sch=$prod_schema_adb_public -f $DIR_LOCAL/sql/drop_tables.sql
source "$DIR/includes/check_status.sh"	

# Import table from dumpfile to target db & schema
echoi $e -n "- Importing tables from dumpfile..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -q --set ON_ERROR_STOP=1 $db_gnrs < $dumpfile
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Removing dumpfile..."
rm $dumpfile
source "$DIR/includes/check_status.sh"	


echoi $e -n "Adjusting permissions..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$target_sch -f $DIR_LOCAL/sql/permissions.sql
source "$DIR/includes/check_status.sh"	
COMMENT_BLOCK_1
######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
