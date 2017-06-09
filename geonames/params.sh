#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Names of files from geonames download
FILES="allCountries.zip alternateNames.zip userTags.zip admin1CodesASCII.txt admin2Codes.txt countryInfo.txt featureCodes_en.txt iso-languagecodes.txt timeZones.txt"

# Main user that will be accessing geonames
USER="bien"

# Path to db_config.sh
# For production, keep outside app working directory & supply
# absolute path
# For development, if keep inside working directory, then supply
# relative path
# Omit trailing slash
db_config_path="/home/boyle/bien3/gnrs"

# Path to general function directory
# If directory is outside app working directory, supply
# absolute path, otherwise supply relative path
# Omit trailing slash
#functions_path=""
functions_path="/home/boyle/functions/sh"

# Path to data directory where files will be downloaded
# Recommend call this "data"
# If directory is outside app working directory, supply
# absolute path, otherwise use relative path (i.e., no 
# forward slash at start).
# Recommend keeping outside app directory
# Omit trailing slash
DATADIR="/home/boyle/bien3/geonames/data"
#DATADIR="data"		 # Relative path

# Some other database to connect to at start, before creating gnrs db
someotherdb="boyle"

# Destination email for process notifications
# You must supply a valid email if you used the -m option
email="bboyle@email.arizona.edu"

# Short name for this operation, for screen echo and 
# notification emails. Number suffix matches script suffix
pname="Import geonames database"

# General process name prefix for email notifications
pname_header_prefix="BIEN notification: process"