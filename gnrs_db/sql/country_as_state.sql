-- -----------------------------------------------------------------
-- Identifies countries belonging to unions, where the union is
-- treated as a country and the country is treated as a state
-- All names must be spelled exactly as in table state_province
-- ---------------------------------------------------------------

UPDATE state_province
SET is_countryasstate=1
WHERE state_province IN (
'England',
'Scotland',
'Wales',
'Northern Ireland'
)
;