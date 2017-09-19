-- ------------------------------------------------------------------
-- Fixes misc errors in GNRS country tables
-- ------------------------------------------------------------------

UPDATE country_name
SET country_name_std='Aland Islands'
WHERE country_name_std LIKE '%land Islands'
;
UPDATE country_name
SET country_name_std='Reunion'
WHERE country_name_std='RÃ©union'
;
UPDATE country_name
SET country_name_std='Saint Barthelemy'
WHERE country_name_std LIKE 'Saint Barth%'
;


INSERT INTO country_name (
country_name,
country_id,
country_name_std
)
SELECT



-- Some missing values
INSERT INTO country_name (
country_name,
country_id,
country_name_std
)
VALUES
(
'Iran',
130758,
'Iran, Islamic Republic of'
),
(
'Saint Barthelemy',
27,
'Saint Barthelemy'
),
(
'Sint Maarten',
211,
'Sint Maarten (Dutch part)'
),
(
'Sint-Maarten',
211,
'Sint Maarten (Dutch part)'
),
(
'Virgin Islands (US)',
239,
'U.S. Virgin Islands'
)
;