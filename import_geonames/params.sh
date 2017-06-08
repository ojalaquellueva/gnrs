#!/bin/bash

# Names of files from geonames download
FILES="allCountries.zip alternateNames.zip userTags.zip admin1CodesASCII.txt admin2Codes.txt countryInfo.txt featureCodes_en.txt iso-languagecodes.txt timeZones.txt"

# subdirectory where files will be downloaded
# Make sure this directory exists, and belongs to group "postgres"
WORKPATH="/home/boyle/bien3/geonames/data"

# Main user that will be accessing geonames
USER="bien"