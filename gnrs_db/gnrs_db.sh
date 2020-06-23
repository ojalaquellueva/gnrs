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
#echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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

# Set includes directory path, relative to $DIR
includes_dir=$DIR"/../includes"

# Load parameters, functions and get command-line options
source "$includes_dir/startup_master.sh"

# Pseudo error log, to absorb screen echo during import
tmplog="/tmp/tmplog.txt"
echo "Error log
" > $tmplog

######################################################
# Custom confirmation message. 
# Will only be displayed if -s (silent) option not used.
######################################################

curr_user=$(whoami)

user_admin_disp=$USER_ADMIN
if [[ "$USER_ADMIN" == "" ]]; then
	user_admin_disp="[none]"
fi

user_read_disp=$USER_READ
if [[ "$USER_READ" == "" ]]; then
	user_admin_disp="[none]"
fi

if [[ "$DOWNLOAD_CROSSWALK" == "t" ]]; then
	download_crossswalk_disp="Yes"
fi

# Reset confirmation message
msg_conf="$(cat <<-EOF

Run process '$pname' using the following parameters: 

GNRS DB:			$DB_GNRS
Geonames DB: 			$DB_GEONAMES
GADM DB:			$DB_GADM
Data directory:			$DATA_DIR
Download crosswalk table:	$download_crossswalk_disp
Current user:			$curr_user
Admin user/db owner:		$user_admin_disp
Additional read-only user:	$user_read_disp
Operation:			$OPERATION

EOF
)"		
confirm "$msg_conf"

# Start time, send mail if requested and echo begin message
source "$includes_dir/start_process.sh"  


: <<'COMMENT_BLOCK_1'



#########################################################################
# Main
#########################################################################

# Run pointless command to trigger sudo password request, 
# needed below. Should remain in effect for all
# sudo commands in this script, regardless of sudo timeout
sudo pwd >/dev/null

if [ "$OPERATION" == "Build GNRS DB" ]; then 

############################################
# Create database in admin role & reassign
# to principal non-admin user of database
############################################

# Check if db already exists
# Warn to drop manually. This is safer.
if psql -lqt | cut -d \| -f 1 | grep -qw "$DB_GNRS"; then
	# Reset confirmation message
	msg="Database '$DB_GNRS' already exists! Please drop first."
	echo $msg; exit 1
fi

echoi $e -n "Creating database '$DB_GNRS'..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "CREATE DATABASE $DB_GNRS" 
source "$includes_dir/check_status.sh"  

echoi $e -n "Changing owner to 'bien'..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "ALTER DATABASE $DB_GNRS OWNER TO bien" 
source "$includes_dir/check_status.sh"  

echoi $e -n "Granting permissions..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -q << EOF
\set ON_ERROR_STOP on
REVOKE CONNECT ON DATABASE gnrs FROM PUBLIC;
GRANT CONNECT ON DATABASE gnrs TO bien;
GRANT CONNECT ON DATABASE gnrs TO public_bien;
GRANT ALL PRIVILEGES ON DATABASE gnrs TO bien;
\c gnrs
GRANT USAGE ON SCHEMA public TO public_bien;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO public_bien;
EOF
echoi $i "done"

echoi $e "Installing extensions:"

echoi $e -n "- fuzzystrmatch..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS -q << EOF
\set ON_ERROR_STOP on
DROP EXTENSION IF EXISTS fuzzystrmatch;
CREATE EXTENSION fuzzystrmatch;
EOF
echoi $i "done"

# For trigram fuzzy matching
echoi $e -n "- pg_trgm..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS -q << EOF
\set ON_ERROR_STOP on
DROP EXTENSION IF EXISTS pg_trgm;
CREATE EXTENSION pg_trgm;
EOF
echoi $i "done"

# For generating unaccented versions of text
echoi $e -n "- unaccent..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS -q << EOF
\set ON_ERROR_STOP on
DROP EXTENSION IF EXISTS unaccent;
CREATE EXTENSION unaccent;
EOF
echoi $i "done"

############################################
# Build core tables
############################################

echoi $e -n "Creating core tables..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/create_core_tables.sql
source "$includes_dir/check_status.sh"  

############################################
# Build political division tables
############################################

echoi $e "Creating poldiv tables in DB $db_geonames:"

echoi $e -n "- Dropping previous GNRS tables if any..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/drop_gnrs_tables.sql
source "$includes_dir/check_status.sh"  

echoi $e -n "- Country..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/country.sql
source "$includes_dir/check_status.sh"

echoi $e -n "-- Fixing errors..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/fix_errors_country.sql
source "$includes_dir/check_status.sh"

echoi $e -n "- State/province..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/state_province.sql
source "$includes_dir/check_status.sh"

echoi $e -n "-- Adding & populating column state_province_std...."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/state_province_std.sql
source "$includes_dir/check_status.sh"

echoi $e -n "-- Fixing errors..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/fix_errors_state_province.sql
source "$includes_dir/check_status.sh"

echoi $e -n "-- Adding & populating column state_province_code2..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/state_province_code2.sql
source "$includes_dir/check_status.sh"

echoi $e -n "- County/parish..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/county_parish.sql
source "$includes_dir/check_status.sh"

echoi $e -n "-- Adding & populating column county_parish_std...."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/county_parish_std.sql
source "$includes_dir/check_status.sh"

echoi $e -n "-- Fixing errors...."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/fix_errors_county_parish.sql
source "$includes_dir/check_status.sh"

echoi $e -n "-- Adding & populating column county_parish_code2..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/county_parish_code2.sql
source "$includes_dir/check_status.sh"

echoi $e -n "- Adjusting permissions for new tables..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -d  $db_geonames -v user_adm=$user_admin -v user_read=$USER_READ -f $DIR/sql/set_permissions_geonames.sql
source "$includes_dir/check_status.sh"	

echoi $e -n "- Reassigning ownership to postgres..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db_geonames --set ON_ERROR_STOP=1 -q -f $DIR/sql/gnrs_tables_change_owner.sql
source "$includes_dir/check_status.sh"  

############################################
# Import geonames tables
############################################

echoi $e "Importing tables from DB $db_geonames to DB $DB_GNRS:"

# Dump table from source databse
echoi $e -n "- Creating dumpfile..."
dumpfile="/tmp/gnrs_geonames_extract.sql"
sudo -u postgres pg_dump --no-owner -t country -t country_name -t state_province -t state_province_name -t county_parish -t county_parish_name 'geonames' > $dumpfile
source "$includes_dir/check_status.sh"	

# Import table from dumpfile to target db & schema
echoi $e -n "- Importing tables from dumpfile..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 $DB_GNRS < $dumpfile > /dev/null >> $tmplog
source "$includes_dir/check_status.sh"	

echoi $e -n "- Removing dumpfile..."
rm $dumpfile
source "$includes_dir/check_status.sh"	

############################################
# Import BIEN2 legacy data
# Includes HASC codes, among other goodies
############################################

echoi $e "Importing legacy BIEN2 data:"

echoi $e -n "- Creating tables...."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/create_bien2_tables.sql
source "$includes_dir/check_status.sh"

# Import metadata file to temp table
echoi $i -n "- Inserting to state_province_bien2..."
sql="
\COPY state_province_bien2 FROM '${DATA_DIR}/${state_province_bien2_file}' DELIMITER ',' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS -q << EOF
\set ON_ERROR_STOP on
$sql
EOF
echoi $i "done"

echoi $i -n "- Inserting to county_parish_bien2..."
sql="
\COPY county_parish_bien2 FROM '${DATA_DIR}/${county_parish_bien2_file}' DELIMITER ',' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS -q << EOF
\set ON_ERROR_STOP on
$sql
EOF
echoi $i "done"

############################################
# Transfer information from bien2 tables
############################################

echoi $e -n "Correcting known issues...."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/correct_errors.sql
source "$includes_dir/check_status.sh"

echoi $e -n "Transferring HASC codes from BIEN2 tables..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/update_hasc_codes.sql
source "$includes_dir/check_status.sh"

echoi $e -n "Dropping BIEN2 tables..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/drop_bien2_tables.sql
source "$includes_dir/check_status.sh"

############################################
# Add any missing names from main table to
# name table
############################################

echoi $e "Adding missing names to table:"

echoi $e -n "- country_name...."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/country_name_add_missing.sql
source "$includes_dir/check_status.sh"

echoi $e -n "- state_province_name...."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/state_province_name_add_missing.sql
source "$includes_dir/check_status.sh"

echoi $e -n "- county_parish_name...."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/county_parish_name_add_missing.sql
source "$includes_dir/check_status.sh"

# Second part of $OPERATION if...elif...fi
elif [ "$OPERATION" == "Import GADM names" ]; then 


COMMENT_BLOCK_1


############################################
# Add GADM political division names
############################################

# WARNING: This approach not yet a pipeline
# Assumes at this point that geonames tables (country, state_province & 
# county_parish) have been exported to gadm database and updated with 
# gadm names. This task, currently performed by gadm.sh as an optional 
# step after importing the gadm database, needs to be moved to here, as 
# it assumes that geonames tables in gnrs db have already been built
# Until this is done, you MUST break the pipeline HERE, build the GADM
# database, with optional step that adds gadm names to the geonames tables,
# then return HERE to import those tables and finish up.

echoi $e "Adding missing GADM political division names"

echoi $e "- Importing revised geonames tables from DB $DB_GADM:"

# Dump table from source databse
echoi $e -n "-- Creating dumpfile..."
dumpfile="/tmp/gnrs_gadm_tables.sql"
sudo -u postgres pg_dump --no-owner -t gadm_country -t gadm_state -t gnrs_county "$DB_GADM"> $dumpfile
source "$includes_dir/check_status.sh"	

# Import table from dumpfile to target db & schema
echoi $e -n "-- Importing tables from dumpfile..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 $DB_GNRS < $dumpfile > /dev/null >> $tmplog
source "$includes_dir/check_status.sh"	

echoi $e -n "-- Removing dumpfile..."
rm $dumpfile
source "$includes_dir/check_status.sh"	

echoi $e "- Adding missing names:"

echoi $e -n "- country...."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/gadm_country_name_add_missing.sql
source "$includes_dir/check_status.sh"

echoi $e -n "- state_province...."
#PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/gadm_state_province_name_add_missing.sql
#source "$includes_dir/check_status.sh"
echo "UNDER CONSTRUCTION"


: <<'COMMENT_BLOCK_2'


# Closing 'else...fi' for $OPERATION if...elif...fi
else
	echo "ERROR: Unknown value '"$OPERATION"' for parameter \$OPERATION"
	exit 1
fi


COMMENT_BLOCK_2


############################################
# Set ownership and permissions
# 
# Performed after either operation
############################################

if [ "$USER_ADMIN" != "" ]; then
	echoi $e "Changing database ownership and permissions:"

	echoi $e -n "- Changing DB owner to '$USER_ADMIN'..."
	sudo -Hiu postgres PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "ALTER DATABASE $DB_GNRS OWNER TO $USER_ADMIN" 
	source "$includes_dir/check_status.sh"  

	echoi $e -n "- Granting permissions..."
	sudo -Hiu postgres PGOPTIONS='--client-min-messages=warning' psql -q <<EOF
	\set ON_ERROR_STOP on
	REVOKE CONNECT ON DATABASE $DB_GNRS FROM PUBLIC;
	GRANT CONNECT ON DATABASE $DB_GNRS TO $USER_ADMIN;
	GRANT ALL PRIVILEGES ON DATABASE $DB_GNRS TO $USER_ADMIN;
EOF
	echoi $i "done"

	echoi $e "- Transferring ownership of non-postgis relations to user '$USER_ADMIN':"
	# Note: views not changed as all at this point are postgis relations

	echoi $e -n "-- Tables..."
	for tbl in `psql -qAt -c "select tablename from pg_tables where schemaname='public' and tableowner<>'postgres';" $DB_GNRS` ; do  sudo -Hiu postgres PGOPTIONS='--client-min-messages=warning' psql -q -c "alter table \"$tbl\" owner to $USER_ADMIN" $DB_GNRS ; done
	source "$includes_dir/check_status.sh"  

	echoi $e -n "-- Sequences..."
	for tbl in `psql -qAt -c "select sequence_name from information_schema.sequences where sequence_schema = 'public';" $DB_GNRS` ; do  sudo -Hiu postgres PGOPTIONS='--client-min-messages=warning' psql -q -c "alter sequence \"$tbl\" owner to $USER_ADMIN" $DB_GNRS ; done
	source "$includes_dir/check_status.sh"  
fi

if [[ ! "$USER_READ" == "" ]]; then
	echoi $e -n "- Granting read access to \"$USER_READ\"..."
	sudo -Hiu postgres PGOPTIONS='--client-min-messages=warning' psql -q <<EOF
	\set ON_ERROR_STOP on
	REVOKE CONNECT ON DATABASE $DB_GNRS FROM PUBLIC;
	GRANT CONNECT ON DATABASE $DB_GNRS TO $USER_READ;
	\c $DB_GNRS
	GRANT USAGE ON SCHEMA public TO $USER_READ;
	GRANT SELECT ON ALL TABLES IN SCHEMA public TO $USER_READ;
EOF
	echoi $i "done"
fi 

######################################################
# Report total elapsed time and exit
######################################################

source "$includes_dir/finish.sh"
