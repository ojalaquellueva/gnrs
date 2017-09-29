#!/bin/bash

#########################################################################
# Purpose: Imports postalcodes and adds to existing geonames database
# ******************** ONE TIME USE ONLY **************************
#
# Usage:	sudo -u postgres ./postalcodes.sh
#
# Warnings:
#	1. Must run as user postgres
#	2. Data directory (set in params file) must exist and must be owned
#		by postgres (e.g., chgrp postgres <data_directory>)
#	3. For one-time use only to save time. Script geonames.sh now
#		includes postalcodes.
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

# Set local working directory
DIR_LOCAL=$DIR		# In that case, the same

# Load parameters, functions and get command-line options
source "$DIR/includes/startup_master.sh"

# Set data directory
DATA_DIR=$data_base_dir

# Adjust process name for emails and echo
pname=$pname_postalcodes
pname_header=$pname_header_prefix" '"$pname"'"

# Confirm operation
source "$DIR/includes/confirm.sh"

# Psuedo error log, to absorb screen echo during import
echo "Error log
" > /tmp/tmplog.txt

#########################################################################
# Main
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

############################################
# Create postalcodes table
############################################

echoi $e -n "Creating table postalcodes..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q  <<EOT
DROP TABLE IF EXISTS postalcodes;
CREATE TABLE postalcodes (
    countrycode CHAR(2),
    postalcode  VARCHAR(20),
    placename   TEXT,
    admin1name  VARCHAR(100),
    admin1code  VARCHAR(20),
    admin2name  VARCHAR(100),
    admin2code  VARCHAR(20),
    admin3name  VARCHAR(100),
    admin3code  VARCHAR(20),
    latitude    FLOAT,
    longitude   FLOAT,
    accuracy    SMALLINT
);
EOT
source "$DIR/includes/check_status.sh"

############################################
# Import postcodes file
############################################

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

echoi $e -n "Inserting data to table..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q <<EOT
copy postalcodes (countrycode,postalcode,placename,admin1name,admin1code,admin2name,admin2code,admin3name,admin3code,latitude,longitude,accuracy) from '${DATADIR}/${PCDIR}/allCountries.txt' WITH CSV DELIMITER E'\t' QUOTE E'\b' NULL AS '';
EOT
source "$DIR/includes/check_status.sh"

######################################################
# Add PKs, indexes and FK constraints
######################################################

echoi $e -n "Indexing..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q  <<EOT
CREATE INDEX postalcodes_countrycode_idx ON postalcodes USING btree (countrycode);
CREATE INDEX postalcodes_admin1name_idx ON postalcodes USING btree (admin1name);
CREATE INDEX postalcodes_admin1code_idx ON postalcodes USING btree (admin1code);
CREATE INDEX postalcodes_admin2name_idx ON postalcodes USING btree (admin2name);
CREATE INDEX postalcodes_admin2code_idx ON postalcodes USING btree (admin2code);
CREATE INDEX postalcodes_admin3name_idx ON postalcodes USING btree (admin3name);
CREATE INDEX postalcodes_admin3code_idx ON postalcodes USING btree (admin3code);
EOT
source "$DIR/includes/check_status.sh"

######################################################
# Adjust permissions as needed
######################################################

# Change owner to main user (bien) and assign read-only access to public_bien
echoi $e -n "Adding permissions for users '$USER' and '$USER_READ'..."
PGOPTIONS='--client-min-messages=warning' psql geonames --set ON_ERROR_STOP=1 -q  <<EOT
GRANT ALL ON postalcodes TO ${USER};
GRANT SELECT ON postalcodes TO ${USER_READ};
EOT
source "$DIR/includes/check_status.sh" 

######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
