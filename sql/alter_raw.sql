-- ----------------------------------------------------------
-- Alter raw data table after import
-- Used only by gnrs_centroids.sh
-- ----------------------------------------------------------

-- Add artifical PK
ALTER TABLE :tbl
ADD COLUMN user_id BIGSERIAL NOT NULL
;

-- Add joining column
ALTER TABLE :tbl
ADD COLUMN poldiv_full text DEFAULT ''
;

-- Change NULLs to ''
UPDATE :tbl
SET 
country=
CASE
WHEN country IS NULL THEN ''
WHEN country='<Null>' THEN ''
ELSE country
END,
state_province=
CASE
WHEN state_province IS NULL THEN ''
WHEN state_province='<Null>' THEN ''
ELSE state_province
END,
county_parish=
CASE
WHEN county_parish IS NULL THEN ''
WHEN county_parish='<Null>' THEN ''
ELSE county_parish
END
;

-- Populate joining column
UPDATE :tbl
SET poldiv_full=CONCAT_WS('@',
trim(country), 
trim(state_province), 
trim(county_parish) 
)
;

-- Index the raw data
CREATE INDEX ON :tbl (country);
CREATE INDEX ON :tbl (state_province);
CREATE INDEX ON :tbl (county_parish);
CREATE INDEX ON :tbl (poldiv_full);

