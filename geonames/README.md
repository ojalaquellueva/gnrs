# Imports geonames database to postgres

Author: Brad Boyle (bboyle@email.arizona.edu)  
Source: http://forum.geonames.org/gforum/posts/list/15/926.page

## Table of Contents

- [Overview](#Overview)
- [Requirements](#Requirements)
- [Schema](#Schema)
- [Usage](#Usage)
- [Notes](#Notes)

### Overview

Creates database geonames & populates with most recent data from http://www.geonames.org/. Assigns full privileges to user $USER, while retaining ownership by postgres. Data files are downloaded to $DATADIR.

### Requirements

Postgres role $USER must exist. Directory $DATADIR must exist, and should either be owned by postgres, or belong to group posgres, e.g.,

```
$ chgrp postgres <data_directory>

```

### Schema

See DDL in sql/create_geonames_tables.sql.

### Usage

```
sudo -u postgres ./geonames.sh

```

### Notes

1. Adapted from http://forum.geonames.org/gforum/posts/list/15/926.page
2. This version does not covert coordinates to geometry
