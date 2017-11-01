select 
poldiv_full, country_verbatim, state_province_verbatim, county_parish_verbatim, poldiv_submitted 
from user_data 
limit 12;

-- Check country only results
select distinct
country_verbatim, 
country,
match_method_country,
match_score_country,
poldiv_matched
from user_data 
order by country_verbatim
limit 12;

-- Check state results
select distinct
country_verbatim, 
state_province_verbatim, 
country,
state_province,
match_method_state_province,
match_score_state_province,
poldiv_matched
from user_data 
order by country,
state_province
limit 12;





SELECT 
a.country_verbatim,
b.country,
similarity(a.country_verbatim,b.country) AS similarity
FROM (
SELECT DISTINCT country_verbatim
FROM user_data
WHERE country IS NULL
) a,
country b
ORDER BY country_verbatim, similarity DESC
LIMIT 12
;