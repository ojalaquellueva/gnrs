-- -----------------------------------------------------------------
-- Identifies states which are part of countries belonging to unions, 
-- where the union is treated as a country, the country is treated 
-- as a state, and the state as a county
-- All names must be spelled exactly as in table county_parish
-- ---------------------------------------------------------------

UPDATE county_parish 
SET is_stateascounty=1
WHERE state_province IN (
'England',
'Scotland',
'Wales',
'Northern Ireland'
)
;