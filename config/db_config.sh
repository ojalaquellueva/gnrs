#!/bin/bash

#########################################################
# Database configuration parameters 
# 
# After setting parameters rename this file to db_config.sh
# For security, recommend keeping this file outside main
# application directory. After move, change db_config_path 
# in params.sh accordingly
#########################################################

# Host
host='localhost'

# GNRS database
db_gnrs="gnrs"		# Name of gnrs database

# Required databases (for building GNRS db only)
db_geonames="geonames" 	# Local geonames database
db_gadm="gadm"			# Local GADM database

# Users
user_admin='<admin-level-user-name>'	# For building GNRS db only
user='<read-only-user-name>' 	# Main admin level user of GNRS
user_read='<read-only-user-name>'	# Read-only user

# Passwords
# to avoid storing here as plain text echo instead
pwd_user_admin=$(cat /path/to/pwddir/user_admin_pwd_file)	# Pwd for user_admin
pgpwd=$(cat /path/to/pwddir/user_pwd_file)					# Pwd for $user
