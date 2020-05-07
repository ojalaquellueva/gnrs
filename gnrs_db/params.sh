#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Name of the GNRS database to build
DB_GNRS="gnrs_dev2"

# Path to db_config.sh
# For production, keep outside app working directory & supply
# absolute path
# For development, if keep inside working directory, then supply
# relative path
# Omit trailing slash
db_config_path="/home/boyle/bien3/gnrs"	# include files require lower case 

# Path to general function directory
# If directory is outside app working directory, supply
# absolute path, otherwise supply relative path
# Omit trailing slash
#functions_path=""
functions_path="/home/boyle/functions/sh"	# include files require lower case 

# Path to data directory for database build
# Recommend call this "data"
# If directory is outside app working directory, supply
# absolute path, otherwise use relative path (i.e., no 
# forward slash at start).
# Recommend keeping outside app directory
# Omit trailing slash
DATA_BASE_DIR="/home/boyle/bien3/gnrs"
DATA_DIR="${DATA_BASE_DIR}/db_data"

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

# Add GADM political division names?
# Requires local GADM database, imported using code in repo 'gadm.git',
# and including custom build political division summary tables.
# Can skip this if don't have gadm database.
# Parameter $db_gadm required if $import_gadm='t'
# Values: t|f
IMPORT_GADM='t'

# t: Download crosswalk table directly from source?
# f: Import from file downloaded manually and copied to data directory
DOWNLOAD_CROSSWALK="t"

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