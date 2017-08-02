-- --------------------------------------------
-- Prepare table county_parish_bien2
-- --------------------------------------------

-- Add extra hasc columns to county/parish 
ALTER TABLE county_parish_bien2
ADD COLUMN hasc_2 TEXT DEFAULT NULL,
ADD COLUMN hasc_full TEXT DEFAULT NULL
;

CREATE INDEX ON county_parish_bien2 (hasc_2_full);

-- Populate hasc_full by joining to state_province table
-- hasc_2_full cannot be trusted
UPDATE county_parish_bien2 a
SET hasc_full=b.hasc_full
FROM state_province_bien2 b
WHERE a.stateprovinceuniquecode=b.state_province_code_unique
;

-- Populate hasc_2 by splitting off last part from hasc_2_full
UPDATE county_parish_bien2
SET hasc_2=split_part(hasc_2_full, '.', 3)
WHERE hasc_2_full IS NOT NULL AND 
hasc_2_full LIKE '%.%.%' 
AND hasc_2_full NOT LIKE '%.%.%.%'
;

-- Now fix hasc_2_full by concatenation 
UPDATE county_parish_bien2
SET hasc_2_full=concat_ws(
'.',hasc_full, hasc_2
)
WHERE hasc_2 is not null and hasc_2 not like '%.%'
and hasc_full like '%.%' and hasc_full not like '%.%.%'
;

CREATE INDEX ON county_parish_bien2 (hasc_2);
CREATE INDEX ON county_parish_bien2 (hasc_full);

-- --------------------------------------------
-- Update the HASC columns in main tables
-- --------------------------------------------

-- Populate state/province HASC codes
UPDATE state_province a
SET hasc=b.hasc,
hasc_full=b.hasc_full
FROM state_province_bien2 b
WHERE a.country_iso=b.country_iso 
AND a.state_province_ascii=b.state_province_std
;

-- Populate county_parish HASC codes
UPDATE county_parish a
SET hasc_2=c.hasc_2,
hasc_2_full=c.hasc_2_full
FROM state_province_bien2 b JOIN county_parish_bien2 c
ON b.state_province_id=c.stateprovinceid
WHERE a.country_iso=b.country_iso 
AND a.state_province_ascii=b.state_province_std
;

