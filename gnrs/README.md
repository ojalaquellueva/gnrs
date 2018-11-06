# Geographic Name Resolution Service (GNRS) Core Application 

Author: Brad Boyle (bboyle@email.arizona.edu)  

## Table of Contents

- [Overview](#overview)
- [Input File](#input-file)
- [Output File](#output-file)
- [Preparation](#preparation)
- [Usage](#usage)

### <a name="Overview"></a>Overview

The GNRS is a batch application for resolving & standardizing political division names against standard name in the Geonames database (http://www.geonames.org/). The GNRS resolves political division names at three levels: country, state/province and county/parish. Resolution is performed in a series steps, beginning with direct matching to standard names, followed by direct matching to alternate names in different languages, followed by direct matching to standard codes (such as ISO and FIPS codes). If direct matching fails, the GNRS attempts to match to standard and then alternate names using fuzzy matching, but does not perform fuzzing matching of political division codes. The GNRS works down the political division hierarchy, stopping at the current level if all matches fail. In other words, if a country cannot be matched, the GNRS does not attempt to match state or county.

The results output by the GNRS include the original political division names, the resolved political division names and IDs (from geonames) and additional information on how each name was resolved and the quality of the overal match.

### <a name="input-file"></a>Input File

The input file for the TNRS must be utf-8 plain text CSV file name gnrs_submitted.csv, with the following fields:

| Field name | Required? | Meaning |
| ----- | ----- | ----- |
| user_id | No | User-supplied integer id for each row, if desired |
| country | Yes | Country name |
| state_province | No | State/province name |
| county_parish | No | County/parish name |

Header "user_id,country,state_province,county_parish" must be included as the first line of the file. This file must be placed in the GNRS user data directory  (see path and directory name in param file). 

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

### <a name="preparation"></a>Preparation

Place your input file in the gnrs user data directory (path and directory name set in param file). input file must be named "gnrs_submitted.csv".

### <a name="Usage"></a>Usage

** Batch processing.** Import, name resolution and export of the results can be run as a single operation by invoking the following script:

```
./gnrs_batch.sh [-option1] [-option2] ...
```

**Separate import, resolution and export***

1. Import input file "gnrs_submitted.csv" from user data directory to GNRS database.

```
$ ./gnrs_import.sh [-option1] [-option2] ...

```

2. Resolve the political division names. Assumes user data has already been loaded to table user_data in the GNRS database.

```
$ ./gnrs.sh [-option1] [-option2] ...

```

3. Export GNRS results from GNRS database to GNRS user data directory as file "gnrs_results.csv":

```
$ ./gnrs_export.sh [-option1] [-option2] ...

```

  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode: suppresses progress messages but not warnings
  	-n: No warnings: suppresses suppresses warnings but not progress
  * Each option listed separately preceded by dash
  * For completely silent operation use "-s -n"
  * For very large file, recommend running in unix screen with -m switch to generate start, completion and error email notifications. A valid email must be provided in params file.
