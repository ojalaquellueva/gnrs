# Fix for GitHub issue #17

## Issue name

See GitHub Issue #17 "The phrase 'region' seems to be missing from scrubbed 'county_parish' names": https://github.com/ojalaquellueva/gnrs/issues/17

## Hotfix

In script `county_parish_hotfix.sql` in this directory. Note also the metadata + version # update.

## Permanent fix to db pipeline code 

In script `gnrs_db/sql/county_parish_std.sql`, where the following 'WHEN ... THEN ...' statement was also added to the long update command preceded by comment "-- Prefixes including article 'de', 'of', etc.":

```
WHEN county_parish_std ILIKE 'Regional District of %' THEN regexp_replace(county_parish_std, 'Regional District of ', '', 'i')
WHEN county_parish_std ILIKE '% Regional District' THEN regexp_replace(county_parish_std, '% Regional District', '', 'i')
```

**Notes:**  
1. The second WHEN...THEN was added to the prefix command, even though it is removing a suffix. This was done as a precaution to ensure this change take place before any later updates (further down in the script) that might corrupt the name.  
2. The above change to the production code has not yet been tested in the context of a full DB rebuild.

