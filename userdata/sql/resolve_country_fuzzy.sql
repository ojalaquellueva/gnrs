-- ------------------------------------------------------------
--  Resolve country
-- ------------------------------------------------------------


-- standard name
UPDATE user_data a
SET
country=fzy.country,
match_method_country='fuzzy standard name',
match_score_country=fzy.similarity
FROM (
SELECT
q.country_verbatim,
p.country,
p.similarity
FROM 
(
SELECT
country_verbatim,
MAX(similarity) AS max_sim
FROM
(
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
) x
GROUP BY country_verbatim
) q 
JOIN 
(
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
) p
ON q.country_verbatim=p.country_verbatim
AND q.max_sim=p.similarity
WHERE q.max_sim>0.75
) AS fzy
WHERE a.country_verbatim=fzy.country_verbatim
AND a.country IS NULL
;


-- Mark complete non-matches
UPDATE user_data
SET poldiv_matched='No match'
WHERE country IS NULL
;


