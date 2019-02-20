# Geographic Name Resolution Service (GNRS)

## Table of Contents

- [Overview](#overview)
- [Software](#software)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Usage](#usage)

### Overview

The GNRS is a batch application for resolving & standardizing political division names against standard name in the Geonames database (http://www.geonames.org/). The GNRS resolves political division names at three levels: country, state/province and county/parish. Resolution is performed in a series steps, beginning with direct matching to standard names, followed by direct matching to alternate names in different languages, followed by direct matching to standard codes (such as ISO and FIPS codes). If direct matching fails, the GNRS attempts to match to standard and then alternate names using fuzzy matching, but does not perform fuzzing matching of political division codes. The GNRS works down the political division hierarchy, stopping at the current level if all matches fail. In other words, if a country cannot be matched, the GNRS does not attempt to match state or county.

This repository contains three components, each in its own subdirectory:

| Application  | Subdirectory | Purpose | 
| ------------- | ------------- | ------------- | 
| GNRS  | gnrs/  | GNRS batch application and web service | 
| GNRS database  | gnrs_db/  | Builds the GNRS database used by the GNRS | 
| Geonames database  | geonames_db/  | Builds the Geonames database, required to build the GNRS database  | 

### Software

**Operating system**

The GNRS runs in the unix environment within the bash shell. The current version was developed on a server with the following attributes:

Ubuntu 14.04.5  
GNU bash, version 4.3.11(1)-release (x86_64-pc-linux-gnu)	 

It has not been tested in other environments. 

**Database**

PostgreSQL 9.3 or higher

### Dependencies

The following PostgreSQL databases must be present:

1. geonames (Required to build the GNRS database)
2. gnrs (Required by gnrs)

### Installation

Clone these directories to the desired location using the structure shown. Each application is run by invoking the master script within its working directory, or by appending the full application path to the script name.

### Usage

See the individual applications for usage instructions.