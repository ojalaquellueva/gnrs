#!/bin/bash

#########################################################################
# Purpose: Loads parameters, functions & issues startup messages
#########################################################################

# Get includes directory
includes_dir="${BASH_SOURCE%/*}"

source "$includes_dir/get_params.sh"	# Parameters, files and paths
source "$includes_dir/functions.sh"	# Load functions file(s)
source "$includes_dir/get_options.sh"	# Get & set command line options

