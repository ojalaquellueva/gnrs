###############################################
# GNRS API Example
#
# Invokes parallel processing GNRS interface (gnrspar.sh)
###############################################

#################################
# Parameters
#################################

# api url
url = "http://vegbiendev.nceas.ucsb.edu:8875/gnrs_ws.php" # production
url = "http://vegbiendev.nceas.ucsb.edu:9875/gnrs_api.php" # development

# Test files of political divisions to resolve
# Comma-delimited, first column an integer ID (can be blank), next three columns
# are country, state, county
# Choose one

# Test data, no ids
testfile <- "https://bien.nceas.ucsb.edu/bien/wp-content/uploads/2020/11/gnrs_testfile.csv"

# Test data with unique ids
testfile.ids <- "https://bien.nceas.ucsb.edu/bien/wp-content/uploads/2020/11/gnrs_testfile_ids.csv"

testfile <- testfile

#################################
# Import & prepare the raw data
#################################

# Load libraries
library(RCurl) # API requests
library(jsonlite) # JSON coding/decoding

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
batches <- 3					# Number of batches, for parallel processing
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

# Construct the request
headers <- list('Accept' = 'application/json', 'Content-Type' = 'application/json', 'charset' = 'UTF-8')

# Start timer
start_time <- Sys.time()

# Send the API request
results_json <- postForm(url, .opts=list(postfields= input_json, httpheader=headers))

# Report processing time
end_time <- Sys.time()
ptime <- end_time - start_time
print(paste0("Batches: ", batches))
print(paste0("Processing time: ", ptime))

# Convert JSON results to a data frame
results <-  jsonlite::fromJSON(results_json)

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
# Example 2: Get metadata for current 
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

# Send the request again
results_json <- postForm(url, .opts=list(postfields= input_json, httpheader=headers))

# Display the results
results <- jsonlite::fromJSON(results_json)
print( results )
