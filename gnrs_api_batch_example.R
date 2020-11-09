#####################################
# Legacy batch api
#
# Runs gnrs_batch.sh (non-parallel). For updated
# test script running parallel gnrs (gnrspar.sh) see
# gnrs_api_example.R
#####################################

# Load libraries
library(RCurl) # API requests
library(rjson) # JSON coding/decoding
library(jsonlite) # JSON coding/decoding

# The test file
testfile <- "https://bien.nceas.ucsb.edu/bien/wp-content/uploads/2020/11/gnrs_testfile.csv"
df_poldivs <- read.csv(testfile, header=TRUE)
df_poldivs

# API url
url = "http://vegbiendev.nceas.ucsb.edu:8875/gnrs_ws.php" # production
url = "http://vegbiendev.nceas.ucsb.edu:9875/gnrs_ws.php" # development

# Convert to JSON
obs_json <- rjson::toJSON(unname(split(df_poldivs, 1:nrow(df_poldivs))))

# Construct the request
headers <- list('Accept' = 'application/json', 'Content-Type' = 'application/json', 'charset' = 'UTF-8')

# Send the API request
start_time <- Sys.time()
results_json <- postForm(url, .opts=list(postfields=obs_json, httpheader=headers))
end_time <- Sys.time()
ptime <- end_time - start_time
cat("Processing time: ", ptime, " sec")

# Convert JSON file to a data frame
results <- jsonlite::fromJSON(results_json)

results[, c('country_verbatim', 'state_province_verbatim', 'county_parish_verbatim', 'country',  'state_province',  'county_parish', 'match_status')]

