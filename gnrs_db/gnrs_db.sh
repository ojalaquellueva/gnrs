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
else
	download_crossswalk_disp="No"

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

#########################################################################
# Main
#########################################################################

# Run pointless command to trigger sudo password request, 
# needed below. Should remain in effect for all
# sudo commands in this script, regardless of sudo timeout
sudo pwd >/dev/null




echo "WARNING: Some code commented out for development!"
: <<'COMMENT_BLOCK_1'




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
sudo -u postgres pg_dump --no-owner -t geoname -t country -t country_name -t state_province -t state_province_name -t county_parish -t county_parish_name 'geonames' > $dumpfile
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

############################################
# Merge GADM political divisions into 
# geonames tables
############################################

echoi $e "Merging GADM political divisions into geonames tables:"

echoi $e -n "- Creating derived GADM poldiv tables in DB '$DB_GADM'..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GADM --set ON_ERROR_STOP=1 -q -f $DIR/sql/create_gadm_poldiv_tables.sql
source "$includes_dir/check_status.sh"	

echoi $e "- Importing GADM poldiv tables:"

echoi $e -n "-- Dropping previous gadm tables, if any..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS -q << EOF
\set ON_ERROR_STOP on
DROP TABLE IF EXISTS gadm_country;
DROP TABLE IF EXISTS gadm_admin_1;
DROP TABLE IF EXISTS gadm_admin_2;
EOF
echoi $i "done"

echoi $e -n "-- Creating dumpfile..."
dumpfile="/tmp/gadm_tables.sql"
sudo -u postgres pg_dump --no-owner -t gadm_country -t gadm_admin_1 -t gadm_admin_2 "$DB_GADM"> $dumpfile
source "$includes_dir/check_status.sh"	

echoi $e -n "-- Importing tables from dumpfile..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 $DB_GNRS < $dumpfile > /dev/null >> $tmplog
source "$includes_dir/check_status.sh"	

echoi $e -n "-- Removing dumpfile..."
rm $dumpfile
source "$includes_dir/check_status.sh"	

######################################################
# Import & unpack Natural Earth iso/hasc code crosswalk
######################################################

echoi $e "Importing ISO/HASC code crosswalk table:"

# Set date/time of access
download_timestamp=$(date '+%F_%H:%M:%S')

# Make subdirectory to hold contents of download 
data_dir_crosswalk=${DATA_DIR}/crosswalk
mkdir -p $data_dir_crosswalk

# Import directly from source if requested
# If this option not used, you MUST manually download the archive,
# extract the dbf file to utf-8 csv, and place it in the crosswalk
# data directory

if [ "$DOWNLOAD_CROSSWALK" == "t" ]; then
	# WARNING: not yet working properly!!!
	echoi $e -n "- Downloading ${ARCHIVE_ADM1_CROSSWALK} to $data_dir_crosswalk..."
	rm -f ${data_dir_crosswalk}/${ARCHIVE_ADM1_CROSSWALK}
	wget -q $URL_ADM1_CROSSWALK -P $data_dir_crosswalk
	source "$includes_dir/check_status.sh"  

	echoi $e -n "- Unzipping archive..."
	unzip -o -q "${data_dir_crosswalk}/${ARCHIVE_ADM1_CROSSWALK}" -d $data_dir_crosswalk
	source "$includes_dir/check_status.sh"  

	# WARNING: not yet working properly!!!
	# Currently Postgres copy command throws the following error:
	# ERROR:  invalid byte sequence for encoding "UTF8": 0x00
	echoi $e -n "- Converting dbf file to CSV..."
	php "$DIR"/php/dbfToCsv.php "${data_dir_crosswalk}/${DBF_ADM1_CROSSWALK}"
	source "$includes_dir/check_status.sh"  
fi

echoi $e -n "- Creating tables..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q 	-f $DIR/sql/create_admin1_crosswalk_raw.sql
source "$includes_dir/check_status.sh"	

echoi $e -n "- Inserting data from file '${CSV_ADM1_CROSSWALK}'..."
sudo -Hiu postgres PGOPTIONS='--client-min-messages=warning' psql $DB_GNRS --set ON_ERROR_STOP=1 -q <<EOT
copy admin1_crosswalk_raw from '${data_dir_crosswalk}/${CSV_ADM1_CROSSWALK}' CSV HEADER;
EOT
source "$includes_dir/check_status.sh"

echoi $e "- Trimming whitespace from all columns in admin1_crosswalk_raw:"
echoi $e -n "-- Generating SQL..."
echo $(PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS -qt -c "SELECT 'UPDATE '||quote_ident(c.table_name)||' SET '||c.COLUMN_NAME||'=TRIM('||quote_ident(c.COLUMN_NAME)||');' as sql_stmt FROM (SELECT table_name,COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name='admin1_crosswalk_raw' AND (data_type='text' or data_type='character varying') ) AS c
")  >> sql/admin1_crosswalk_raw_trim_ws.sql
source "$includes_dir/check_status.sh"

echoi $e -n "-- Executing SQL..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/admin1_crosswalk_raw_trim_ws.sql
source "$includes_dir/check_status.sh"

echoi $e -n "- Inserting data to table admin1_crosswalk..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/create_admin1_crosswalk.sql
source "$includes_dir/check_status.sh"

echoi $e -n "- Altering table admin1_crosswalk..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/admin1_crosswalk_alter.sql
source "$includes_dir/check_status.sh"	

echoi $e -n "- Dropping table admin1_crosswalk_raw..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -c "DROP TABLE IF EXISTS admin1_crosswalk_raw"
source "$includes_dir/check_status.sh"

######################################################
# Index gadm political divisions with geonames IDs
######################################################

echoi $e "Linking gadm political divisions to geonames:"

echoi $e -n "- Countries..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/gadm_geonames_index_country.sql 
source "$includes_dir/check_status.sh"

echoi $e -n "- Admin 1..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/gadm_geonames_index_admin_1.sql
source "$includes_dir/check_status.sh"

echoi $e -n "- Admin 2..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/gadm_geonames_index_admin_2.sql
source "$includes_dir/check_status.sh"





COMMENT_BLOCK_1


######################################################
# Add missing gadm names to gnrs-geonames tables
######################################################

echoi $e "Adding new gadm political divisions to geonames tables:"

echoi $e -n "- Countries..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/geonames_add_gadm_country.sql > /dev/null
source "$includes_dir/check_status.sh"

echoi $e -n "- Admin 1..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/geonames_add_gadm_admin_1.sql > /dev/null
source "$includes_dir/check_status.sh"

echoi $e -n "- Admin 2..."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/geonames_add_gadm_admin_2.sql > /dev/null
source "$includes_dir/check_status.sh"

echoi $e "Adding missing GADM alternate names:"

echoi $e -n "- country...."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/gadm_country_name_add_missing.sql
source "$includes_dir/check_status.sh"

echoi $e -n "- state_province...."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/gadm_state_province_name_add_missing.sql
source "$includes_dir/check_status.sh"

echoi $e -n "- county_parish...."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/gadm_county_parish_name_add_missing.sql
source "$includes_dir/check_status.sh"

echoi $e -n "Adding GADM IDs...."
PGOPTIONS='--client-min-messages=warning' psql -d $DB_GNRS --set ON_ERROR_STOP=1 -q -f $DIR/sql/add_gadm_ids.sql
source "$includes_dir/check_status.sh"

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
