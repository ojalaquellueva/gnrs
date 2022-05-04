###############################################
# GNRS API Examples
#
# Invokes parallel processing GNRS interface (gnrspar.sh)
###############################################

rm(list=ls())

#################################
# Parameters
#################################

# api url
url = "https://gnrsapi.xyz/gnrs_api.php" 

# Test files of political divisions to resolve (choose one)
# Format: comma-delimited UTF-8 text
# Columns:
#   user_id: optional unique identifier. Can be blank but comma placeholder required
#   country: required
#   state: optional, country required if included
#   county: optional, country and state required if included

# Test data with unique ids
testfile.ids <- "https://bien.nceas.ucsb.edu/bien/wp-content/uploads/2020/11/gnrs_testfile_ids.csv"

# Test data, no ids
testfile.noids <- "https://bien.nceas.ucsb.edu/bien/wp-content/uploads/2020/11/gnrs_testfile.csv"

# Set the input file
testfile <- testfile.ids

# Load libraries
library(httr)		# API requests
library(jsonlite) # JSON coding/decoding

#################################
# Import & prepare the raw data
#################################

# Read in example file of taxon names
data <- read.csv(testfile, header=TRUE)

# Inspect the input data
head(data,25)

# Uncomment to work with smaller sample of the data
#data <- head(data,8)

# Convert the data to JSON
data_json <- jsonlite::toJSON(unname(data))

#################################
# Example 1: Resolve
#################################

# Set API options
mode <- "resolve"			# Processing mode
batches <- 10					# Number of batches, for parallel processing
										# input file will be divided into this many batches

# Convert the options to data frame and then JSON
opts <- data.frame( c(mode) )
names(opts) <- c("mode")
if ( exists("batches") ) opts$batches <- batches

opts_json <-  jsonlite::toJSON(opts)
opts_json <- gsub('\\[','',opts_json)
opts_json <- gsub('\\]','',opts_json)

# Combine the options and data into single JSON object
input_json <- paste0('{"opts":', opts_json, ',"data":', data_json, '}' )

# Send the API request
results_json <- POST(url = url,
                  add_headers('Content-Type' = 'application/json'),
                  add_headers('Accept' = 'application/json'),
                  add_headers('charset' = 'UTF-8'),
                  body = input_json,
                  encode = "json"
                  )

# Convert JSON results to a data frame
results_raw <- fromJSON(rawToChar(results_json$content)) 
results <- as.data.frame(results_raw)

# Inspect the results
head(results, 10)

# Display header plus one row vertically
# to better compare the output fields
results.t <- as.data.frame( t( results[,1:ncol(results)] ) )
results.t[,3,drop =FALSE]

# Display columns showing how each political division level was matched
results[ , c( 'country_verbatim', 'state_province_verbatim', 'county_parish_verbatim', 
	'country', 'state_province', 'county_parish', 
	'match_method_country', 'match_method_state_province', 'match_method_county_parish')
	]

# Display columns showing overall completeness of match
results[ , c('country_verbatim', 'state_province_verbatim', 'county_parish_verbatim', 
	'country', 'state_province', 'county_parish', 'match_method_country', 
	'poldiv_submitted', 'poldiv_matched', 'match_status')
	]

# Display alternative IDs returned in addition to names.
# IDs beginning "gid_" are gadm identifiers
# geonameid refers is for the lowest political division matched
results[ , c(	'country', 'state_province', 'county_parish', 
	'country_iso', 'state_province_iso', 'county_parish_iso', 
	'gid_0', 'gid_1', 'gid_2', 'geonameid' )
	]

#################################
# Example 2: Get list of all countries & 
# associated information in GNRS DB
# Parameters: none
#################################
rm( list = Filter( exists, c("results", "results_json") ) )

# All we need to do is reset option mode.
# all other options will be ignored
mode <- "countrylist"		

# Re-form the options json again
# Note that only 'mode' is needed
opts <- data.frame(c(mode))
names(opts) <- c("mode")
opts_json <- jsonlite::toJSON(opts)
opts_json <- gsub('\\[','',opts_json)
opts_json <- gsub('\\]','',opts_json)

# Input json requires only the option
input_json <- paste0('{"opts":', opts_json, '}' )

# Send the API request
results_json <- POST(url = url,
                  add_headers('Content-Type' = 'application/json'),
                  add_headers('Accept' = 'application/json'),
                  add_headers('charset' = 'UTF-8'),
                  body = input_json,
                  encode = "json"
                  )

# Convert JSON results to a data frame
results <- as.data.frame( fromJSON( rawToChar( results_json$content ) ) )

# Display the results
print( results )

# Save list of countries for use in state query
countries.all <- results
	
#################################
# Example 3: Get list of states & associated
# information for subset of countries
# Parameters: one or more value of country_id
#################################
rm( list = Filter( exists, c("results", "results_json") ) )

# Make list of countries for which you'd like to get list of states
# Filter however you want, but value used for data_json
# must be the integer country_id
countries <- as.data.frame(countries.all[ countries.all$country 
	%in% c('Costa Rica', 'Nicaragua', 'Panama'), c('country_id')])
# Or set to empty string ("") to get everything:
#countries <- as.data.frame("")	
names(countries ) <- c("country_id")
data_json <- jsonlite::toJSON(countries)

mode <- "statelist"		
opts <- data.frame(c(mode))
names(opts) <- c("mode")
opts_json <- jsonlite::toJSON(opts)
opts_json <- gsub('\\[','',opts_json)
opts_json <- gsub('\\]','',opts_json)

# Form the input json, including both options and data
input_json <- paste0('{"opts":', opts_json, ',"data":', data_json, '}' )

# Send the API request
results_json <- POST(url = url,
                  add_headers('Content-Type' = 'application/json'),
                  add_headers('Accept' = 'application/json'),
                  add_headers('charset' = 'UTF-8'),
                  body = input_json,
                  encode = "json"
                  )

# Convert JSON results to a data frame
results <- as.data.frame( fromJSON( rawToChar( results_json$content ) ) )

# Display the results
print( results )		
print( paste0( "Total rows returned: ", nrow(results) ) )

# Save list of states for use in county query
states.all <- results

#################################
# Example 4: Get list of counties & associated
# information for subset of states in one or
# more countries
# Parameters: one or more pairs of 
# country_id + state_province_id
#################################
rm( list = Filter( exists, c("results", "results_json") ) )

# Make list of states for which you'd like to get list of counties
# Filter however you want, but value used for data_json parameters
# must be the integer state_province_id
states <- as.data.frame(states.all[ states.all$state_province_id 
	%in% c(3624953, 3624368, 3830308, 3620673), c('state_province_id')])
# Or set to empty string ("") to get everything:
#states <- as.data.frame("")	
names(states ) <- c("state_province_id")
data_json <- jsonlite::toJSON(states)

mode <- "countylist"		
opts <- data.frame(c(mode))
names(opts) <- c("mode")
opts_json <- jsonlite::toJSON(opts)
opts_json <- gsub('\\[','',opts_json)
opts_json <- gsub('\\]','',opts_json)

# Form the input json, including both options and data
input_json <- paste0('{"opts":', opts_json, ',"data":', data_json, '}' )

# Send the API request
results_json <- POST(url = url,
                  add_headers('Content-Type' = 'application/json'),
                  add_headers('Accept' = 'application/json'),
                  add_headers('charset' = 'UTF-8'),
                  body = input_json,
                  encode = "json"
                  )

# Convert JSON results to a data frame
results <- as.data.frame( fromJSON( rawToChar( results_json$content ) ) )

# Display the results
print( results )
print( paste0( "Total rows returned: ", nrow(results) ) )

#################################
# Example 5: Get data dictionary of GNRS 
# output
#################################
rm( list = Filter( exists, c("results", "results_json") ) )

# All we need to do is reset option mode.
# all other options will be ignored
mode <- "dd"		

# Re-form the options json again
# Note that only 'mode' is needed
opts <- data.frame(c(mode))
names(opts) <- c("mode")
opts_json <- jsonlite::toJSON(opts)
opts_json <- gsub('\\[','',opts_json)
opts_json <- gsub('\\]','',opts_json)

# Make the options
# No data needed
input_json <- paste0('{"opts":', opts_json, '}' )

# Send the API request
results_json <- POST(url = url,
                  add_headers('Content-Type' = 'application/json'),
                  add_headers('Accept' = 'application/json'),
                  add_headers('charset' = 'UTF-8'),
                  body = input_json,
                  encode = "json"
                  )

# Convert JSON results to a data frame
results <- as.data.frame( fromJSON( rawToChar( results_json$content ) ) )

# Display the results
print( results )

#################################
# Example 6: Get metadata for current 
# GNRS version
#################################
rm( list = Filter( exists, c("results", "results_json") ) )

# All we need to do is reset option mode.
# all other options will be ignored
mode <- "meta"		

# Re-form the options json again
# Note that only 'mode' is needed
opts <- data.frame(c(mode))
names(opts) <- c("mode")
opts_json <- jsonlite::toJSON(opts)
opts_json <- gsub('\\[','',opts_json)
opts_json <- gsub('\\]','',opts_json)

# Make the options
# No data needed
input_json <- paste0('{"opts":', opts_json, '}' )

# Send the API request
results_json <- POST(url = url,
                  add_headers('Content-Type' = 'application/json'),
                  add_headers('Accept' = 'application/json'),
                  add_headers('charset' = 'UTF-8'),
                  body = input_json,
                  encode = "json"
                  )

# Convert JSON results to a data frame
results <- as.data.frame( fromJSON( rawToChar( results_json$content ) ) )

# Display the results
print( results )

#################################
# Example 7: Get metadata for all 
# GNRS sources
#################################
rm( list = Filter( exists, c("results", "results_json") ) )

# Set sources mode
mode <- "sources"		

# Re-form the options json again
# Note that only 'mode' is needed
opts <- data.frame(c(mode))
names(opts) <- c("mode")
opts_json <- jsonlite::toJSON(opts)
opts_json <- gsub('\\[','',opts_json)
opts_json <- gsub('\\]','',opts_json)

# Make the options
# No data needed
input_json <- paste0('{"opts":', opts_json, '}' )

# Send the API request
results_json <- POST(url = url,
                  add_headers('Content-Type' = 'application/json'),
                  add_headers('Accept' = 'application/json'),
                  add_headers('charset' = 'UTF-8'),
                  body = input_json,
                  encode = "json"
                  )

# Convert JSON results to a data frame
results <- as.data.frame( fromJSON( rawToChar( results_json$content ) ) )

# Display the results
print( results )

#################################
# Example 8: Get bibtex citations for GNRS 
# data sources and the GNRS
#################################
rm( list = Filter( exists, c("results", "results_json") ) )

# Set citations mode
mode <- "citations"		

# Re-form the options json again
# Note that only 'mode' is needed
opts <- data.frame(c(mode))
names(opts) <- c("mode")
opts_json <- jsonlite::toJSON(opts)
opts_json <- gsub('\\[','',opts_json)
opts_json <- gsub('\\]','',opts_json)

# Make the options
# No data needed
input_json <- paste0('{"opts":', opts_json, '}' )

# Send the API request
results_json <- POST(url = url,
                  add_headers('Content-Type' = 'application/json'),
                  add_headers('Accept' = 'application/json'),
                  add_headers('charset' = 'UTF-8'),
                  body = input_json,
                  encode = "json"
                  )

# Convert JSON results to a data frame
results <- as.data.frame( fromJSON( rawToChar( results_json$content ) ) )

# Display the results
print( results )

#################################
# Example 9: GNRS project contributors
# (For acknowledgements)
#################################
rm( list = Filter( exists, c("results", "results_json") ) )

# Set mode
mode <- "collaborators"		

# Re-form the options json again
# Note that only 'mode' is needed
opts <- data.frame(c(mode))
names(opts) <- c("mode")
opts_json <- jsonlite::toJSON(opts)
opts_json <- gsub('\\[','',opts_json)
opts_json <- gsub('\\]','',opts_json)

# Make the options
# No data needed
input_json <- paste0('{"opts":', opts_json, '}' )

# Send the API request
results_json <- POST(url = url,
                  add_headers('Content-Type' = 'application/json'),
                  add_headers('Accept' = 'application/json'),
                  add_headers('charset' = 'UTF-8'),
                  body = input_json,
                  encode = "json"
                  )

# Convert JSON results to a data frame
results <- as.data.frame( fromJSON( rawToChar( results_json$content ) ) )

# Display the results
print( results )

