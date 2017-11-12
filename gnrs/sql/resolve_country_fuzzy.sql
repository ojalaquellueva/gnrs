-- ------------------------------------------------------------
--  Resolve country
-- ------------------------------------------------------------


-- standard name
UPDATE user_data a
SET
country_id=fzy.country_id,
country=fzy.country,
match_method_country='fuzzy standard name',
match_score_country=fzy.similarity
FROM (
SELECT
q.country_verbatim,
p.country_id,
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
b.country_id,
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
WHERE q.max_sim>:match_threshold
) AS fzy
WHERE a.country_verbatim=fzy.country_verbatim
AND a.country IS NULL
;

-- alternate name
UPDATE user_data a
SET
country_id=fzy.country_id,
country=fzy.country,
match_method_country='fuzzy alternate name',
match_score_country=fzy.similarity
FROM (
SELECT
q.country_verbatim,
p.country_id,
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
similarity(a.country_verbatim,b.country_name) AS similarity
FROM (
SELECT DISTINCT country_verbatim
FROM user_data
WHERE country IS NULL
) a,
(SELECT country, country_name FROM country a JOIN country_name b
ON a.country_id=b.country_id WHERE name_type='original from geonames') b
) x
GROUP BY country_verbatim
) q 
JOIN 
(
SELECT 
a.country_verbatim,
b.country_id,
b.country,
similarity(a.country_verbatim,b.country_name) AS similarity
FROM (
SELECT DISTINCT country_verbatim
FROM user_data
WHERE country IS NULL
) a,
(SELECT a.country_id, country, country_name FROM country a JOIN country_name b
ON a.country_id=b.country_id WHERE name_type='original from geonames') b
) p
ON q.country_verbatim=p.country_verbatim
AND q.max_sim=p.similarity
WHERE q.max_sim>:match_threshold
) AS fzy
WHERE a.country_verbatim=fzy.country_verbatim
AND a.country IS NULL
;
