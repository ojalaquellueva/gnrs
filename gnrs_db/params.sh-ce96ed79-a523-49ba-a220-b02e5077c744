#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

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

# Path to data directory
# Recommend call this "data"
# If directory is outside app working directory, supply
# absolute path, otherwise use relative path (i.e., no 
# forward slash at start).
# Recommend keeping outside app directory
# Omit trailing slash
data_base_dir="/home/boyle/bien3/gnrs/data"
#data_base_dir="data"		 # Relative path

# Text file state/province and county/parisgh HASC codes, compiled for bien2
state_province_bien2_file="stateProvince_utf8.csv"
county_parish_bien2_file="countyParish_utf8.csv"

# Read only user to add to new tables
user_read="public_bien"

# Destination email for process notifications
# You must supply a valid email if you used the -m option
email="bboyle@email.arizona.edu"

# Short name for this operation, for screen echo and 
# notification emails. Number suffix matches script suffix
pname="Build GNRS database"

# General process name prefix for email notifications
pname_header_prefix="BIEN notification: process"