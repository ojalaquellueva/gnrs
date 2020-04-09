#!/bin/bash

#########################################################
# Database connection parameters
# 
# After setting parameters rename this file to db_config.sh
# For security, recommend keeping this file outside main
# application directory. After move, change db_config_path 
# in params.sh accordingly
#########################################################


# Host
host='localhost'

# Databases
db_gnrs="gnrs"	# Name of main gnrs database
db_geonames="geonames" # Geonames, needed for building gnrs DB

# Users
user_admin='<admin-level-user-name>'	# For building GNRS DB only
user='<read-only-user-name>' 	# Main admin level user of GNRS
user_read='<read-only-user-name>'	# Read-only user

# Passwords
pwd_user_admin=$(cat /path/to/pwddir/user_admin_pwd_file)	# Pwd for user_admin
pgpwd=$(cat /path/to/pwddir/user_pwd_file)		# Pwd for $user
