# Geographic Name Resolution Service (GNRS) 

Author: Brad Boyle (bboyle@email.arizona.edu)  

## Table of Contents

- [Overview](#Overview)
- [Software](#Software)
- [Dependencies](#Dependencies)
- [Installation and configuration](#installation)
- [Maintenance](#maintenance)
- [Input File](#input-file)
- [Output File](#output-file)
- [Usage](#Usage)
- [API](#api)

### <a name="Overview"></a>Overview

The GNRS is a batch application for resolving & standardizing political division names against standard name in the Geonames database (http://www.geonames.org/). The GNRS resolves political division names at three levels: country, state/province and county/parish. Resolution is performed in a series steps, beginning with direct matching to standard names, followed by direct matching to alternate names in different languages, followed by direct matching to standard codes (such as ISO and FIPS codes). If direct matching fails, the GNRS attempts to match to standard and then alternate names using fuzzy matching, but does not perform fuzzing matching of political division codes. The GNRS works down the political division hierarchy, stopping at the current level if all matches fail. In other words, if a country cannot be matched, the GNRS does not attempt to match state or county.

The results output by the GNRS include the original political division names, the resolved political division names and IDs (from geonames) and additional information on how each name was resolved and the quality of the overal match.

## <a name="Software"></a>Software

Ubuntu 16.04 or higher  
PostgreSQL/psql 12.2, or higher

## <a name="Dependencies"></a>Dependencies

Local installation of database `geonames`, required for building the GNRS database, is included in this repo. See subdirectory `db_geonames`.

## <a name="installation"></a>Installation and configuration

I recommend the following setup:

```
# Create application base directory (call it whatever you want)
mkdir -p gnrs
cd gnrs

# Create application code directory
mkdir src

# Install application code to application code directory
cd src
git clone https://github.com/ojalaquellueva/gnrs

# Move data and sensitive parameters directories outside of code directory
# Be sure to change paths to these directories (in params.sh) accordingly
mv data ../
mv config ../
```

Note: temporary data directory in /tmp/gnrs (used by gnrs api) is installed on the fly by the application.

### <a name="maintenance"></a>Maintenance

To avoid filling up the gnrs temp directory, consider adding a crontab entry to delete files older than a certain number of days. For example, the following cron job find and deletes all files older than 7 days, every day at 4:02 am:

```
02 4 * * * find /tmp/gnrs/* -type f -mtime +7 -print0 | xargs -0 rm
``` 

Another version for systems that don't support -print0:

```
02 4 * * * find /tmp/gnrs/* -type f -mtime +7 -exec rm {} \;
```

Whichever you use, be sure to test first to verify that the list of files makes sense:

```
find /tmp/gnrs/* -type f -mtime +7 
```

### <a name="input-file"></a>Input File

The input file for the TNRS must be utf-8 plain text CSV file name gnrs_submitted.csv, with the following fields:

| Field name | Required? | Meaning |
| ----- | ----- | ----- |
| user_id | No | User-supplied integer id for each row, if desired |
| country | Yes | Country name |
| state_province | No | State/province name |
| county_parish | No | County/parish name |

Header `user_id,country,state_province,county_parish` must be the first line of the file. Place this file in the GNRS user data directory (`data/user/`; path and directory name set in file params.sh). 

### <a name="output-file"></a>Output File

GNRS output is saved to the GNRS user data directory as a utf-8 CSV file with header named gnrs_results.csv. Fields are as follows:

| Field name | Meaning |
| ----- | ----- |
| id | gnrs ID of each record |
| poldiv_full | Verbatim country, state/province and county/parish, concatenated with '@' dellimiter |
| country_verbatim | Verbatim country |
| state_province_verbatim | Verbatim state/province |
| county_parish_verbatim | Verbatim county/parish |
| country | Resolved country |
| state_province | Resolved state/province |
| county_parish | Resolve couny/parish |
| country_id | Geonames ID of resolved country |
| state_province_id | Geonames ID of resolved state/province |
| county_parish_id | Geonames ID of resolve county/parish |
| match_method_country | Method used to match country |
| match_method_state_province | Method used to match state/province |
| match_method_county_parish | Method used to match county/parish |
| match_score_country | Country match score (if fuzzy matched) |
| match_score_state_province | State/province match score (if fuzzy matched) |
| match_score_county_parish | County/parish match score (if fuzzy matched) |
| poldiv_submitted | Lowest political division submitted |
| poldiv_matched | Lowest political division matched |
| match_status | Completeness of overall match |
| user_id | User id, if supplied |

Place your input file in the gnrs user data directory (path and directory name set in param file). input file must be named "gnrs_submitted.csv".

### <a name="Usage"></a>Usage

#### GNRS batch application
Import, name resolution and export of results are run as a single operation by invoking the following script:

```
./gnrs_batch.sh [-option1] [-option2] ...
```

Options (listed separately preceded by dash; do not combine):  
  -m: Send notification emails  
  -s: Silent mode: suppress all (confirmations & progress messages)  
  -p: Use PGPASSWORD authentication (required for API call)  
  
Example:

```
./gnrs_batch.sh -f "data/user/test_data.csv"

```
* The above assumes data directory and test file are stil inside application directory (as structured in this repo). Adjust path accordingly if you move data directory outside the repo, as recommended above under [Installation and configuration](#installation).

#### Legacy usage: import, resolve, export

This approach has been replaced by the single file `gnrs_batch.sh`. File `gnrs.sh` is the core GNRS script invoked by `gnrs_batch.sh`. Scripts `gnrs_import.sh` and `gnrs_export.sh` are no longer needed but I am retaining now for internal use for compatibility with legacy BIEN applications. 

1. Import input file "gnrs_submitted.csv" from user data directory to GNRS database.

```
$ ./gnrs_import.sh [-option1] [-option2] ...

```

2. Resolve the political division names. Assumes user data has already been loaded to table user_data in the GNRS database. This is the core GNRS script.

```
$ ./gnrs.sh [-option1] [-option2] ...

```

3. Export GNRS results from GNRS database to GNRS user data directory as file "gnrs_results.csv":

```
$ ./gnrs_export.sh [-option1] [-option2] ...

```

Component service options:  
  -m: Send notification emails    
  -n: No warnings: suppress confirmations but not progress messages  
  -s: Silent mode: suppress all (confirmations & progress messages)  

  
### <a name="example"></a>Example


### <a name="api"></a>API

See API documentation in separate repository `http://bien.nceas.ucsb.edu/bien/tools/gnrs/gnrs-api/`