# Imports geonames database to postgres

Author: Brad Boyle (bboyle@email.arizona.edu)  
Source: http://forum.geonames.org/gforum/posts/list/15/926.page

## Table of Contents

- [Overview](#Overview)
- [Requirements](#Requirements)
- [Schema](#Schema)
- [Usage](#Usage)
- [Notes](#Notes)

### <a name="Overview"></a>Overview

Creates database geonames & populates with most recent data from http://www.geonames.org/. Assigns full privileges to user $USER, while retaining ownership by postgres. Data files are downloaded to $DATADIR.

### <a name="Requirements"></a>Requirements

Postgres role $USER must exist. Directory $DATADIR must exist, and should either be owned by postgres, or belong to group posgres, e.g.,

```
$ chgrp postgres <data_directory>

```

### <a name="Schema"></a>Schema

See DDL in sql/create_geonames_tables.sql.

### <a name="Usage"></a>Usage

```
sudo -u postgres ./geonames.sh

```

### <a name="Notes"></a>Notes

1. Adapted from http://forum.geonames.org/gforum/posts/list/15/926.page
2. This version does not covert coordinates to geometry
