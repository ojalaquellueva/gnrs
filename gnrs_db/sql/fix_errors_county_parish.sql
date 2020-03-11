-- ------------------------------------------------------------------
-- Fixes misc errors in GNRS county_parish tables
-- ------------------------------------------------------------------

-- Fill in missing country_ids
-- Not sure why this is happening, but small number of records (~30)
-- are missing country_id, even though they have text country name
-- and iso code
-- This hack will fix until I can find the bug
UPDATE county_parish a
SET country_id=b.country_id
FROM country b
WHERE a.country_iso=b.iso
AND a.country_id IS NULL
;

-- Also not sure what this is happening. Only one record like this
DELETE FROM county_parish_name
WHERE county_parish_name='' OR county_parish_name IS NULL
;
