#!/bin/bash

#########################################################################
# Purpose: Creates and populates GNRS database 
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 21 April 2017
#########################################################################

: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

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
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Load parameters, functions and get command-line options
source "$DIR/includes/startup_master.sh"

# Confirm operation
source "$DIR/includes/confirm.sh"

#########################################################################
# Main
#########################################################################

############################################
# Create database in admin role & reassign
# to principal non-admin user of database
############################################

# Check if db already exists
if psql -lqt | cut -d \| -f 1 | grep -qw "$db_gnrs"; then
	# Reset confirmation message
	msg_conf="Drop existing database '$db_gnrs'?"
	confirm "$msg_conf"

	echoi $e -n "Dropping database '$db_gnrs'..."
	PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "DROP DATABASE $db_gnrs" 
	source "$DIR/includes/check_status.sh"  
fi

echoi $e -n "Creating database '$db_gnrs'..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "CREATE DATABASE $db_gnrs" 
source "$DIR/includes/check_status.sh"  

# Change owner to main user (bien)
echoi $e -n "Setting owner to '$user'..."
PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "ALTER DATABASE $db_gnrs OWNER TO $user" 
source "$DIR/includes/check_status.sh" 

############################################
# Import geonames
############################################

echoi $e -n "Creating geonames tables...."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_gnrs --set ON_ERROR_STOP=1 -q -f sql/create_geonames_tables.sql
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
