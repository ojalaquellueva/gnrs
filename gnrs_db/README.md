# Builds GNRS database

Author: Brad Boyle (bboyle@email.arizona.edu)  

## Table of Contents

- [Overview](#Overview)
- [Requirements](#Requirements)
- [Usage](#Usage)

### <a name="Overview"></a>Overview

Builds GNRS database in part from selected entities in geonames database (see http://www.geonames.org/). Main tables are built inside database geonames them imported into database gnrs. Additional information (principally HASC codes) are imported from previous BIEN database. Required by main GNRS application.

### <a name="Requirements"></a>Requirements

Postgres database geonames must exist on local machine. See separate geonames import scripts in directory geonames/ in this repository. Schema of geonames must be as in geonames/sql/create_geonames_tables.sql.

### <a name="Usage"></a>Usage

```
$ ./gnrs_db.sh [-option1] [-option2] 

```

  * Options:  
  	-m: Send notification emails  
  	-s: Silent mode; no screen echoes or prompts  
  * Recommend run in unix screen with -m switch to generate start, stop and error emails. Valid email must be provided in params.sh.
  	