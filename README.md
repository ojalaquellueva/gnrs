# Geographic Name Resolution Service (GNRS) 

Author: Brad Boyle (bboyle@email.arizona.edu)  

## Table of Contents

- [Overview](#Overview)
- [Software](#Software)
- [Dependencies](#Dependencies)
- [Installation and configuration](#installation)
- [Maintenance](#maintenance)
- [Input/Output](#input-output)
  - [Input File](#input-file)
  - [Input File Type](#input-file-type)
  - [Output File](#output-file)
- [Usage](#Usage)
  - [GNRS (parallel processing)](#gnrs-parallel)
  - [GNRS batch (non-parallel)](#gnrs-batch)
- [API](#api)

<a name="Overview"></a>
## Overview

The GNRS is a batch application for resolving & standardizing political division names against the GADM Global Administrative Divisions Database (https://gadm.org/), with additional names and codes from Geonames (http://www.geonames.org/) and Natural Earth (https://www.naturalearthdata.com/). The GNRS resolves political division names at three levels: country (admin\_0), state/province (admin\_1) and county/parish (admin\_2). Resolution is performed in a series steps, beginning with direct matching to standard names, followed by direct matching to alternate names in different languages, followed by direct matching to standard codes (such as ISO and FIPS codes). If direct matching fails, the GNRS attempts to match to standard and then alternate names using fuzzy matching, but does not perform fuzzing matching of political division codes. The GNRS works down the political division hierarchy, stopping at the current level if all matches fail. In other words, if a country cannot be matched, the GNRS does not attempt to match state or county.

Results returned by the GNRS include the original political division names, the resolved political division names and IDs from GADM and Geonames, with additional information on how each name was resolved and the quality of the overal match.

<a name="Software"></a>
## Software

Ubuntu 16.04 or higher  
PostgreSQL 12.2 or higher  
Perl v5.26.1 or higher  
Perl module `Text::CSV`  
PHP 7.2.24 or higher  
PHP extensions:   
* php-cli  
* php-mbstring  
* php-curl  
* php-xml  
* php-json  
* php-services-json  
* php-pgsql

<a name="Dependencies"></a>
## Dependencies

1. Local installation of database `geonames`
  * Required for building the GNRS database
  * See repo: `https://github.com/ojalaquellueva/geonames.git'
2. Local installation of database `gadm`
  * Required for building the GNRS database
  * See repo: `https://github.com/ojalaquellueva/gadm.git'

<a name="installation"></a>
## Installation and configuration

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

<a name="maintenance"></a>
## Maintenance

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

<a name="input-output"></a>
## Input/Output

<a name="input-file"></a>
### Input File

The input file for the TNRS must be utf-8 plain text file name with the following fields:

| Field name | Required? | Meaning |
| ----- | ----- | ----- |
| user_id | No | User-supplied integer id for each row, if desired |
| country | Yes | Country name |
| state_province | No | State/province name |
| county_parish | No | County/parish name |

Header `user_id,country,state_province,county_parish` must be the first line of the file. Place this file in the GNRS user data directory (`data/user/`; path and directory name set in file params.sh). 

#### Example tab-delimited data
* Numeric IDs optional but must include header & all tabs 

```
user_id<tab>country<tab>state_province<tab>county_parish  
1<tab>Russia<tab>Lipetsk<tab>Dobrovskiy rayon  
2<tab>Mexico<tab>Sonora, Estado de<tab>Huépac  
3<tab>Guatemala<tab>Izabal<tab>  
4<tab>USA<tab>Arizona<tab>Pima County  
5<tab>U.S.A<tab>Arizona<tab>Pima<tab>  
6<tab>Mexico<tab>Quintana Roo<tab>Lázaro Cárdenas
``` 

<a name="input-file-type"></a>
#### Input File Type
* `gnrspar.pl`: must be tab delimited
* `gnrs_batch.sh`: tab delimited or comma delimited. Specify on command line (see below).

<a name="output-file"></a>
### Output File

GNRS output is saved as a utf-8 CSV file with header. By default, the name of the output file is the basename of the input file, plus suffix "gnrs\_results.csv". Fields are as follows:

| Field name | Meaning |
| ----- | ----- |
| id | gnrs ID of each record |
| poldiv\_full | Verbatim country, state/province and county/parish, concatenated with '@' dellimiter |
| country\_verbatim | Verbatim country |
| state\_province\_verbatim | Verbatim state/province |
| county\_parish\_verbatim | Verbatim county/parish |
| country | Resolved country |
| state\_province | Resolved state/province |
| county\_parish | Resolve couny/parish |
| country\_id | Geonames ID of resolved country |
| state\_province\_id | Geonames ID of resolved state/province |
| county\_parish\_id | Geonames ID of resolve county/parish |
| match\_method\_country | Method used to match country |
| match\_method\_state\_province | Method used to match state/province |
| match\_method\_county\_parish | Method used to match county/parish |
| match\_score\_country | Country match score (if fuzzy matched) |
| match\_score\_state\_province | State/province match score (if fuzzy matched) |
| match\_score\_county\_parish | County/parish match score (if fuzzy matched) |
| poldiv\_submitted | Lowest political division submitted |
| poldiv\_matched | Lowest political division matched |
| match\_status | Completeness of overall match |
| user\_id | User id, if supplied |

Place your input file in the gnrs user data directory (path and directory name set in param file). input file must be named "gnrs\_submitted.csv".

<a name="Usage"></a>
## Usage

<a name="gnrs-parallel"></a>
### GNRS (parallel processing)
* This should be considered the default application as it is by far the fastest
* Splits submitted file into batches, removing duplicates, and processes several batches at once using multiple cores.
* Reassembles batches into single file when all batches complete
* Invokes `gnrs_batch.sh` (see below)

#### Syntax

```
./gnrspar.pl -in <input_filename_and_path> -nbatch <batches> -opt <makeflow_options> <other options>
```

#### Options

Option | Meaning | Required? | Default value | Values  
------ | ------- | -------  | :--------: | --- |  
-in     | Input file and path | Yes | | |  
-out     | Output file and path | No | /path/to/<inputfilename>\_gnrs\_results.tsv | |  
-nbatch     | Number of batches | Yes |  | |  
-opt     | Makeflow options | No |  |  
-d     | Output file delimiter | No | t | c (CSV), t (TSV)|  

#### Example:

```
./gnrspar.pl -in "../data/user/gnrs_testfile.csv" -nbatch 3
```

<a name="gnrs-batch"></a>
### GNRS batch (non-parallel)
Import, name resolution and export of results are run as a single operation by invoking the following script:

```
./gnrs_batch.sh [-option1] [-option2] ...
```

#### Options

Option | Purpose | Required? | Default value | Comments
------ | ------- | -------  | ---------- | ---- |
  -f | Input file and path  | Yes | |  
  -o | Output file and path  | No | /path/to/<inputfilename>\_gnrs\_results.csv |  
  -d | Output file delimiter  | No | c |  c=comma (CSV), t=tab (TSV)
  -n | No header | No | FALSE | Input file does not contain header. Default value (FALSE) means file contains header as first line.
  -a | Api call  | No (yes for api) | | invokes other options such as -s and -p
  -s | Silent mode: suppress all (confirmations & progress messages)  | No | |   
  -m | Send notification emails  | No | |  Must be followed by valid email
  -r | Remove from cache | No | FALSE | Remove any results corresponding to submitted political divisions from cache. Forces resolution from scratch of all values in current batch.
  -c | Clear cache | No | FALSE | Clear entire cache

  
Example:

```
./gnrs_batch.sh -f "../data/user/gnrs_testfile.csv" -o "/home/boyle/testing/gnrs_testfile_scrubbed.csv"

```
* The above assumes command is being run from same directory as target script, `gnrs_batch.sh`. 
* If running from a different directory, pre-prend the command with path to `gnrs_batch.sh`, unless you have added this path to your environment
* In this example, path to data directory is relative to working directory. Yoiu could also use the full path.
* Output file "gnrs_testfile_scrubbed.csv" will be dumped to directory "/home/boyle/testing/"


### <a name="api"></a>API

For up-to-date examples of API usage in php and R, see the following example files in the `api/` subdirectory of this reposotory:

```
gnrs_api_example.php
gnrs_api_example.R
```

Also see API documentation at `http://bien.nceas.ucsb.edu/bien/tools/gnrs/gnrs-api/`