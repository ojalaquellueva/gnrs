-- -----------------------------------------------
-- Correct misc know errors in the 
-- -----------------------------------------------


UPDATE state_province_bien2
SET state_province_std='Quebec'
WHERE country_iso='CA' AND state_province_std='Québec'
;

UPDATE state_province
SET state_province='New Brunswick',
state_province_ascii='New Brunswick',
state_province_std='New Brunswick'
WHERE country_iso='CA' AND state_province='New Brunswick/Nouveau-Brunswick'
;
