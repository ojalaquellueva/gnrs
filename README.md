# GNRS

> Geographic Name Resolution Service

## Table of Contents

- [Overview](#Overview)
- [Usage](#usage)

## Overview

Batch application for resolving & standardizing political division names. Matches one- to three-level, hierarchical political division names to standard name from the Geonames database (http://www.geonames.org/).

## Usage

1. Import geonames database:

```
sudo -u posgres ./geonames.sh

```

2. Build gnrs database:

```
sudo -u posgres ./gnrs_db.sh

```

3. GNRS batch application:

