-- ----------------------------------------------------------
-- Manual fixes to content
-- Not yet added to pipeline
-- ----------------------------------------------------------

-- Correct erroneous standard state_province names
UPDATE state_province
SET state_province='Mayagüez Municipio',
state_province_ascii='Mayaguez Municipio',
state_province_std='Mayaguez'
WHERE country_iso='PR'
AND state_province_std='Mayagueez'
;
UPDATE state_province
SET state_province_std=TRIM(REPLACE(state_province_std,'Municipio de',''))
WHERE country_iso='PR'
AND state_province_std LIKE 'Municipio de%'
;
UPDATE state_province
SET state_province_std='Tibet'
WHERE country_iso='CN'
AND state_province='Tibet Autonomous Region'
;
