#!/bin/bash

#########################################################################
# Purpose: Creates geonames database & populates with latest data from
#	geonames download 
#
# Usage:	sudo -u postgres ./geonames.sh
#
# Warnings:
#	1. Must run as user postgres
#	2. Data directory (set in params file) must exist and must be owned
#		by postgres (e.g., chgrp postgres <data_directory>)
#
# Based in part on the following script, with alterations:
#	http://forum.geonames.org/gforum/posts/list/15/926.page
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

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
#DIR="${BASH_SOURCE%/*}"
#if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
DIR="$PWD"

# Load parameters, functions and get command-line options
source "$DIR/includes/startup_master.sh"

# Confirm operation
source "$DIR/includes/confirm.sh"

# Set local directories to same as main
#data_dir_local=$data_base_dir
DIR_LOCAL=$DIR

# Psuedo error log, to absorb screen echo during import
echo "Error log
" > /tmp/tmplog.txt

#########################################################################
# Main
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

############################################
# Create database & tables
############################################

: <<'COMMENT_BLOCK_1'

# Check if db already exists
if psql -lqt | cut -d \| -f 1 | grep -qw "geonames"; then
	# Reset confirmation message
	msg_conf="Replace existing database 'geonames'?"
	confirm "$msg_conf"

	echoi $e -n "Dropping database 'geonames'..."
	PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "DROP DATABASE geonames" 
	source "$DIR/includes/check_status.sh"  
fi

echoi $e -n "Creating database 'geonames'..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "CREATE DATABASE geonames" 
source "$DIR/includes/check_status.sh"  

echoi $e -n "Creating geonames tables...."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q -f sql/create_geonames_tables.sql
source "$DIR/includes/check_status.sh"

############################################
# Import geonames files
############################################

cd "$DATADIR"
echoi $e "Importing geonames files to directory $(pwd):"
for i in $FILES
do
	echoi $e -n "- "$i"..."
	wget -N -q "http://download.geonames.org/export/dump/$i" # get newer files
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo "cannot download $i file: Aborting. Error="$RETVAL && exit $RETVAL
	
	if [ $i -nt "_$i" ] || [ ! -e "_$i" ] ; then
		cp -p $i "_$i"
		if [ `expr index zip $i` -eq 1 ]; then
			unzip -o -u -q $i
		fi
		
		# Remove headers and comments from selected files
		case "$i" in
			iso-languagecodes.txt)
				tail -n +2 iso-languagecodes.txt > iso-languagecodes.txt.tmp;
			;;
			countryInfo.txt)
				grep -v '^#' countryInfo.txt | head -n -2 > countryInfo.txt.tmp;
			;;
			timeZones.txt)
				tail -n +2 timeZones.txt > timeZones.txt.tmp;
			;;
		esac
		echoi $e "downloaded";
	else
		echoi $e "already the latest version"
	fi
done

# Move to data directory 
pcpath=$DATADIR"/"$PCDIR
cd $pcpath

echoi $e -n "Downloading file 'allCountries.zip'..."
wget -q -N "http://download.geonames.org/export/zip/allCountries.zip"
source "$DIR/includes/check_status.sh"

echoi $e -n "Unzipping file..."
unzip -u -q $pcpath/allCountries.zip
source "$DIR/includes/check_status.sh"

############################################
# Insert the data
############################################

# Back to original working directory
cd "$DIR"

echoi $e "Inserting data to tables:"

echoi $e -n "- geoname..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q <<EOT
copy geoname (geonameid,name,asciiname,alternatenames,latitude,longitude,fclass,fcode,country,cc2,admin1,admin2,admin3,admin4,population,elevation,gtopo30,timezone,moddate) from '${DATADIR}/allCountries.txt' null as '';
EOT
source "$DIR/includes/check_status.sh"

PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q <<EOT
copy postalcodes (countrycode,postalcode,placename,admin1name,admin1code,admin2name,admin2code,admin3name,admin3code,latitude,longitude,accuracy) from '${DATADIR}/${PCDIR}/allCountries.txt' WITH CSV DELIMITER E'\t' QUOTE E'\b' NULL AS '';
EOT
source "$DIR/includes/check_status.sh"

echoi $e -n "- timezones..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q <<EOT
copy timezones (countrycode,timezoneid,gmt_offset,dst_offset,raw_offset) from '${DATADIR}/timeZones.txt.tmp' null as '';
EOT
source "$DIR/includes/check_status.sh"

echoi $e -n "- featurecodes..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q <<EOT
copy featurecodes (code,name,description) from '${DATADIR}/featureCodes_en.txt' null as '';
EOT
source "$DIR/includes/check_status.sh"

echoi $e -n "- admin1CodesAscii..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q <<EOT
copy admin1codesascii (code,name,nameascii,geonameid) from '${DATADIR}/admin1CodesASCII.txt' null as '';
EOT
source "$DIR/includes/check_status.sh"

echoi $e -n "- admin2codesascii..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q <<EOT
copy admin2codesascii (code,name,nameascii,geonameid) from '${DATADIR}/admin2Codes.txt' null as '';
EOT
source "$DIR/includes/check_status.sh"

echoi $e -n "- iso_languagecodes..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q <<EOT
copy iso_languagecodes (iso_639_3,iso_639_2,iso_639_1,language_name) from '${DATADIR}/iso-languagecodes.txt.tmp' null as '';
EOT
source "$DIR/includes/check_status.sh"

echoi $e -n "- countryinfo..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q <<EOT
copy countryinfo (iso_alpha2,iso_alpha3,iso_numeric,fips_code,country,capital,areainsqkm,population,continent,tld,currency_code,currency_name,phone,postal,postalregex,languages,geonameid,neighbours,equivalent_fips_code) from '${DATADIR}/countryInfo.txt.tmp' null as '';
EOT
source "$DIR/includes/check_status.sh"

echoi $e -n "- alternatename..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q <<EOT
copy alternatename (alternatenameid,geonameid,isolanguage,alternatename,ispreferredname, isshortname, iscolloquial, ishistoric) from '${DATADIR}/alternateNames.txt' null as '';
EOT
source "$DIR/includes/check_status.sh"

echoi $e -n "- continentcodes..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q <<EOT
INSERT INTO continentcodes VALUES ('AF', 'Africa', 6255146);
INSERT INTO continentcodes VALUES ('AS', 'Asia', 6255147);
INSERT INTO continentcodes VALUES ('EU', 'Europe', 6255148);
INSERT INTO continentcodes VALUES ('NA', 'North America', 6255149);
INSERT INTO continentcodes VALUES ('OC', 'Oceania', 6255150);
INSERT INTO continentcodes VALUES ('SA', 'South America', 6255151);
INSERT INTO continentcodes VALUES ('AN', 'Antarctica', 6255152);
EOT
source "$DIR/includes/check_status.sh"

######################################################
# Add PKs, indexes and FK constraints
######################################################

echoi $e -n "Indexing tables...."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q -f sql/index_geonames_tables.sql
source "$DIR/includes/check_status.sh"
COMMENT_BLOCK_1

######################################################
# Adjust permissions as needed
######################################################

# Change owner to main user (bien) and assign read-only access to public_bien
echoi $e -n "Adding permissions for users '$USER' and '$USER_READ'..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q -v user_adm=$USER -v user_read=$USER_READ -f sql/set_permissions.sql
source "$DIR/includes/check_status.sh" 

######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
