#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Fuzzy match threshold (trigram similarity score)
# [0-1], recommend at least 0.5 to avoid false positives
match_threshold=0.5

# Short unique code for this user or data source
# Must be same as name of ultimate data subdirectory
src="centroids"

# Name of the raw data file to be imported. 
# Place in the designated data directory
data_raw="centroid_data_10_19_2017.csv"

# 't' to limit number of records imported (for testing)
# 'f' to run full import
use_limit='f'
recordlimit=1000

# Names of raw data table(s)
# Name of first table is automatic
# If additional tables, recommend _raw2, _raw3, although such
# naming convention may not be useful if many tables involved
tbl_raw=$src"_raw"

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
data_base_dir="/home/boyle/bien3/gnrs/userdata/"$src
#data_base_dir="data"		 # Relative path

# Destination email for process notifications
# You must supply a valid email if you used the -m option
email="bboyle@email.arizona.edu"

# Short name for this operation, for screen echo and 
# notification emails. Number suffix matches script suffix
pname="GNRS"

# General process name prefix for email notifications
pname_header_prefix="BIEN notification: process"