#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Operation to be performed
# Values: "Build GNRS DB" | "Import GADM names"
# If OPERATION="Build GNRS DB", will build GNRS db from scratch. 
# Requires local geonames db.
# OPERATION="Import GADM names", will add GADM names to existing
# GNRS database. Requires local gadm database, including geonames
# tables (country, state_province, county_parish) extracted from 
# GNRS database. 
# A complete build of the GNRS database therefore requires four steps:
# 1. Build geonames database
# 2. Run this script with OPERATION="Build GNRS DB"
# 3. Build gadm database (requires GNRS db)
# 4. Run this script with OPERATION="Import GADM names"
#OPERATION="Build GNRS DB"
#OPERATION="Import GADM names"

# Name of the GNRS database to build
DB_GNRS="gnrs_dev"

# Path to db_config.sh
# For production, keep outside app working directory & supply
# absolute path
# For development, if keep inside working directory, then supply
# relative path
# Omit trailing slash
db_config_path="/home/bien/gnrs/config"	# include files require lower case 

# Path to general function directory
# If directory is outside app working directory, supply
# absolute path, otherwise supply relative path
# Omit trailing slash
#functions_path=""
functions_path="/home/bien/gnrs/src/includes"	

# Path to data directory for database build
# Recommend call this "data"
# If directory is outside app working directory, supply
# absolute path, otherwise use relative path (i.e., no 
# forward slash at start).
# Recommend keeping outside app directory
# Omit trailing slash
DATA_BASE_DIR="/home/bien/gnrs/data/"
DATA_DIR="${DATA_BASE_DIR}/db"

# Base application directory
DB_BASE_DIR="/home/boyle/bien/gnrs/src"

# Main application directory
DB_DIR="${DB_BASE_DIR}/gnrs_db"

# Text file state/province and county/parisgh HASC codes, compiled for bien2
state_province_bien2_file="stateProvince_utf8.csv"
county_parish_bien2_file="countyParish_utf8.csv"

#########################################################
# Database admin/owner user and read-only users to add
#
# To omit adding any user, set value to empty string ""
# If no users added, database will be owned by user postgres
#########################################################

# Admin-level user, will be made owner of database and relations
USER_ADMIN="bien"

# Read only user to add to new tables
USER_READ="public_bien"

#########################################################
# Parameters for reference data and databases
#########################################################

# Name of other databases required to build the GNRS DB
DB_GEONAMES="geonames"
DB_GADM="gadm"

########################################################
# Natural Earth crosswalk table parameters
########################################################

# Download crosswalk data directly from source?
# Values:
#	t 	Download directly from source
#	f 	Import from file already present in data directory)
# If $DOWNLOAD_CROSSWALK="f", you MUST manually download the archive,
# extract the dbf file to utf-8 csv, and place it in the crosswalk
# data directory
DOWNLOAD_CROSSWALK="f"

# Link to dbf file of admin1 political divisions and codes
# Needed for linking GADM admin1 to geonames admin1
# Once unzipped, you still need to be able to dump the dbf file
URL_ADM1_CROSSWALK="https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip"

# The archive should just be the basename of the url, but 
# adjust accordingly if not
ARCHIVE_ADM1_CROSSWALK=$(basename $URL_ADM1_CROSSWALK)

# Name of dbf file that needs to be unpacked. 
# Adjust accordingly if this formula changes
DBF_ADM1_CROSSWALK=${ARCHIVE_ADM1_CROSSWALK/.zip/.dbf}

# This is only crosswalk file nameparameter needed needed
# if not importing directly from source
CSV_ADM1_CROSSWALK=${DBF_ADM1_CROSSWALK/.dbf/.csv}

#########################################################
# Miscellaneous parameters
#########################################################

# Destination email for process notifications
# You must supply a valid email if you used the -m option
email="bboyle@email.arizona.edu"

# Short name for this operation, for screen echo and 
# notification emails. Number suffix matches script suffix
pname="Build GNRS database "

# General process name prefix for email notifications
pname_header_prefix="BIEN notification: process"