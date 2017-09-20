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
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "CREATE DATABASE $db_gnrs" 
source "$DIR/includes/check_status.sh"  

echoi $e -n "Changing owner to 'postgres'..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "ALTER DATABASE $db_gnrs OWNER TO bien" 
source "$DIR/includes/check_status.sh"  

############################################
# Build core tables
############################################

echoi $e -n "Creating core tables..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/create_core_tables.sql
source "$DIR/includes/check_status.sh"  

############################################
# Build political division tables
############################################

echoi $e "Creating poldiv tables in DB $db_geonames:"

echoi $e -n "- Dropping previous GNRS tables if any..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/drop_gnrs_tables.sql
source "$DIR/includes/check_status.sh"  

echoi $e -n "- Country..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/country.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- State/province..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/state_province.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Adding & populating column state_province_std...."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/state_province_std.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Fixing errors..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/fix_errors_state_province.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- County/parish..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/county_parish.sql
source "$DIR/includes/check_status.sh"

#echoi $e -n "-- Fixing errors...."
#PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/fix_errors_county_parish.sql
#source "$DIR/includes/check_status.sh"

echoi $e -n "- Adjusting permissions for new tables..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -d  $db_geonames -v user_adm=$user_bien -v user_read=$user_read -f $DIR_LOCAL/sql/set_permissions_geonames.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Reassigning ownership to postgres..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/gnrs_tables_change_owner.sql
source "$DIR/includes/check_status.sh"  


############################################
# Import geonames tables
############################################

echoi $e "Importing tables from DB $db_geonames to DB $db_gnrs:"

# Dump table from source databse
echoi $e -n "- Creating dumpfile..."
dumpfile="/tmp/gnrs_geonames_extract.sql"
sudo -u postgres pg_dump --no-owner -t country -t country_name -t state_province -t state_province_name -t county_parish -t county_parish_name 'geonames' > $dumpfile
source "$DIR/includes/check_status.sh"	

# Import table from dumpfile to target db & schema
echoi $e -n "- Importing tables from dumpfile..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 $db_gnrs < $dumpfile > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Removing dumpfile..."
rm $dumpfile
source "$DIR/includes/check_status.sh"	

############################################
# Import BIEN2 legacy data
# Includes HASC codes, among other goodies
############################################

echoi $e "Importing legacy BIEN2 data:"

echoi $e -n "- Creating tables...."
PGOPTIONS='--client-min-messages=warning' psql -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/create_bien2_tables.sql
source "$DIR/includes/check_status.sh"

# Import metadata file to temp table
echoi $i -n "- Inserting to state_province_bien2..."
sql="
\COPY state_province_bien2 FROM '${data_dir_local}/${state_province_bien2_file}' DELIMITER ',' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql -d $db_gnrs -q << EOF
\set ON_ERROR_STOP on
$sql
EOF
echoi $i "done"

echoi $i -n "- Inserting to county_parish_bien2..."
sql="
\COPY county_parish_bien2 FROM '${data_dir_local}/${county_parish_bien2_file}' DELIMITER ',' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql -d $db_gnrs -q << EOF
\set ON_ERROR_STOP on
$sql
EOF
echoi $i "done"

############################################
# Adjust permissions
############################################

echoi $e -n "Adjusting permissions..."
for tbl in `psql -qAt -c "select tablename from pg_tables where schemaname = 'public';" $db_gnrs` ; do  psql -c "alter table \"$tbl\" owner to bien" $db_gnrs > /dev/null >> $tmplog; done
source "$DIR/includes/check_status.sh"

############################################
# Transfer information from bien2 tables
############################################
: <<'COMMENT_BLOCK_2'
COMMENT_BLOCK_2

echoi $e -n "Correcting known issues...."
PGOPTIONS='--client-min-messages=warning' psql -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/correct_errors.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "Transferring HASC codes from BIEN2 tables..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/update_hasc_codes.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "Dropping BIEN2 tables..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_gnrs --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/drop_bien2_tables.sql
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
