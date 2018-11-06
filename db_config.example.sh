#!/bin/bash

### Set parameters and rename to db_config.sh ###

# Database connection parameters
# For production, keep these parameters outside script working directory
# Edit db_config_path in params.sh accordingly
host='localhost'

user_admin='<admin-level-user-name>'
user_read='<read-only-user-name>'
user='<read-only-user-name>' # Can be same as user_read

pwd_user_admin="<admin-level-user-password>"

db_geonames="geonames"
db_gnrs="gnrs"
