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

--
-- Check match results
-- 
SELECT
country_verbatim AS cv, 
state_province_verbatim AS spv, 
county_parish_verbatim AS cpv,
country_id AS c_id,
state_province_id AS sp_id,
county_parish_id as cp_id,
case 
when match_method_country ilike '%exact%' then 'exact' 
when match_method_country ilike '%fuzzy%' then 'fuzzy' 
else match_method_country
end
as mm_c,
case 
when match_method_state_province ilike '%exact%' then 'exact' 
when match_method_state_province ilike '%fuzzy%' then 'fuzzy' 
else match_method_state_province
end
as mm_sp,
case 
when match_method_county_parish ilike '%exact%' then 'exact' 
when match_method_county_parish ilike '%fuzzy%' then 'fuzzy' 
else match_method_county_parish
end
as mm_cp,
match_score_country AS ms_c,
match_score_state_province AS ms_sp,
match_score_county_parish AS ms_cp,
poldiv_submitted AS submitted,
poldiv_matched AS matched,
match_status
FROM user_data
LIMIT 12
;

SELECT
country_verbatim AS cv, 
state_province_verbatim AS spv, 
county_parish_verbatim AS cpv,
country_id AS c_id,
state_province_id AS sp_id,
county_parish_id as cp_id,
poldiv_submitted AS submitted,
poldiv_matched AS matched,
match_status
FROM user_data
WHERE match_status='partial match' and poldiv_submitted='state_province'
order by country_verbatim, state_province_verbatim, county_parish_verbatim
;


-- Count match statuses
SELECT
match_status, count(*)
from user_data
group by match_status
;

-- Count match status x match level
SELECT
match_status, poldiv_matched, count(*)
from user_data
group by match_status, poldiv_matched
order by match_status, poldiv_matched
;

SELECT
match_status, poldiv_submitted, poldiv_matched, count(*)
from user_data
group by match_status, poldiv_submitted, poldiv_matched
order by match_status, poldiv_submitted, poldiv_matched
;

-- Count types of matches as well
SELECT
match_status, poldiv_submitted, poldiv_matched, match_method_state_province, count(*)
from user_data
where match_status='partial match' and poldiv_submitted='state_province'
group by match_status, poldiv_submitted, poldiv_matched, match_method_state_province
order by match_status, poldiv_submitted, poldiv_matched, match_method_state_province
;



