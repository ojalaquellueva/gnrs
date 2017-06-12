# Builds GNRS database

Author: Brad Boyle (bboyle@email.arizona.edu)  

## Table of Contents

- [Overview](#Overview)
- [Requirements](#Requirements)
- [Schema](#Schema)
- [Usage](#Usage)
- [Notes](#Notes)

### <a name="Overview"></a>Overview

Builds GNRS database in part from selected entities in geonames database (see http://www.geonames.org/).

### <a name="Requirements"></a>Requirements

Postgres database geonames must exist on local filesystem. See separate geonames import scripts in directory geonames/ in this repository. Schema of geonames must be as in DDL (see geonames/sql/create_geonames_tables.sql).

### <a name="Schema"></a>Schema

...

### <a name="Usage"></a>Usage

```
$ ./gnrs_db.sh -m

```

  * Operation will abort if any SQL fails
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode  
  	


### <a name="Notes"></a>Notes

