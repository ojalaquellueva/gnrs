#!/bin/bash

### Set all parameters and rename to params.sh ####

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Names of files from geonames download
FILES="allCountries.zip alternateNames.zip userTags.zip admin1CodesASCII.txt admin2Codes.txt countryInfo.txt featureCodes_en.txt iso-languagecodes.txt timeZones.txt"

# Main user that will be accessing geonames
# This user is assigned all privileges, but ownership remains with postgres
USER="<some_admin_level_postgres_user>"

# Read only user, will be able to select tables
USER_READ="<some_read_level_postgres_user>"

# Path to db_config.sh
# For production, keep outside app working directory & supply
# absolute path
# For development, if keep inside working directory, then supply
# relative path. If in same directory as this file, set to "".
# Omit trailing slash
db_config_path="<path/to/db_config_file_directory>"

# Path to general function directory
# If directory is outside app working directory, supply
# absolute path, otherwise supply relative path
# Omit trailing slash
#functions_path=""
functions_path="<path/to/functions_file_directory>"

# Path to data directory where files will be downloaded
# Recommend call this "data"
# If directory is outside app working directory, supply
# absolute path, otherwise use relative path (i.e., no 
# forward slash at start).
# Recommend keeping outside app directory
# Omit trailing slash
DATADIR="data"		 # Relative path

# Postal code data directory
# This should be a subdirectory of the data directory
# Omit slashes
PCDIR="pcodes"

# Destination email for process notifications
# You must supply a valid email if you used the -m option
email="<your_email_address>"

# Short name for this operation, for screen echo and 
# notification emails. Number suffix matches script suffix
pname="Import geonames database"
pname_postalcodes="Import geonames postalcodes"

# General process name prefix for email notifications
pname_header_prefix="Process"