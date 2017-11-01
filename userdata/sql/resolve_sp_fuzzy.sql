-- ------------------------------------------------------------
--  Resolve state_province
-- ------------------------------------------------------------

-- standard name
UPDATE user_data a
SET
state_province=fzy.state_province_std,
match_method_state_province='fuzzy name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country,
p.state_province,
p.similarity
FROM 
(
SELECT
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country,
a.state_province_verbatim,
b.state_province,
similarity(a.state_province_verbatim,b.state_province) AS similarity
FROM (
SELECT DISTINCT country, state_province_verbatim
FROM user_data
WHERE country IS NOT NULL AND state_province IS NULL
) a,
(SELECT a.country, b.state_province FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country=b.country
) x
GROUP BY state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country,
a.state_province_verbatim,
b.state_province,
similarity(a.state_province_verbatim,b.state_province) AS similarity
FROM (
SELECT DISTINCT country, state_province_verbatim
FROM user_data
WHERE country IS NOT NULL AND state_province IS NULL
) a,
(SELECT a.country, b.state_province FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country=b.country
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.max_sim=p.similarity
WHERE q.max_sim>0.75
) AS fzy
WHERE a.state_province_verbatim=fzy.state_province_verbatim
AND a.country=fzy.country
AND a.state_province IS NULL
;

-- standard ascii name
UPDATE user_data a
SET
state_province=fzy.state_province_std,
match_method_state_province='fuzzy ascii name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country,
p.state_province,
p.similarity
FROM 
(
SELECT
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country,
a.state_province_verbatim,
b.state_province,
similarity(a.state_province_verbatim,b.state_province_ascii) AS similarity
FROM (
SELECT DISTINCT country, state_province_verbatim
FROM user_data
WHERE country IS NOT NULL AND state_province IS NULL
) a,
(SELECT a.country, b.state_province FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country=b.country
) x
GROUP BY state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country,
a.state_province_verbatim,
b.state_province,
similarity(a.state_province_verbatim,b.state_province_ascii) AS similarity
FROM (
SELECT DISTINCT country, state_province_verbatim
FROM user_data
WHERE country IS NOT NULL AND state_province IS NULL
) a,
(SELECT a.country, b.state_province FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country=b.country
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.max_sim=p.similarity
WHERE q.max_sim>0.75
) AS fzy
WHERE a.state_province_verbatim=fzy.state_province_verbatim
AND a.country=fzy.country
AND a.state_province IS NULL
;

-- short ascii name
UPDATE user_data a
SET
state_province=fzy.state_province_std,
match_method_state_province='fuzzy ascii short name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country,
p.state_province,
p.similarity
FROM 
(
SELECT
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country,
a.state_province_verbatim,
b.state_province,
similarity(a.state_province_verbatim,b.state_province_std) AS similarity
FROM (
SELECT DISTINCT country, state_province_verbatim
FROM user_data
WHERE country IS NOT NULL AND state_province IS NULL
) a,
(SELECT a.country, b.state_province FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country=b.country
) x
GROUP BY state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country,
a.state_province_verbatim,
b.state_province,
similarity(a.state_province_verbatim,b.state_province_std) AS similarity
FROM (
SELECT DISTINCT country, state_province_verbatim
FROM user_data
WHERE country IS NOT NULL AND state_province IS NULL
) a,
(SELECT a.country, b.state_province FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country=b.country
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.max_sim=p.similarity
WHERE q.max_sim>0.75
) AS fzy
WHERE a.state_province_verbatim=fzy.state_province_verbatim
AND a.country=fzy.country
AND a.state_province IS NULL
;

-- alternate name
-- standard name
UPDATE user_data a
SET
state_province=fzy.state_province_std,
match_method_state_province='fuzzy name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country,
p.state_province_std,
p.similarity
FROM 
(
SELECT
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country,
a.state_province_verbatim,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province_name) AS similarity
FROM (
SELECT DISTINCT country, state_province_verbatim
FROM user_data
WHERE country IS NOT NULL AND state_province IS NULL
) a,
(SELECT c.country, state_province_std, state_province_name FROM state_province a JOIN state_province_name b ON a.state_province_id=b.state_province_id JOIN country c ON a.country_id=c.country_id WHERE name_type='original from geonames') b
WHERE a.country=b.country
) x
GROUP BY state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country,
a.state_province_verbatim,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province_name) AS similarity
FROM (
SELECT DISTINCT country, state_province_verbatim
FROM user_data
WHERE country IS NOT NULL AND state_province IS NULL
) a,
(SELECT c.country, state_province_std, state_province_name FROM state_province a JOIN state_province_name b ON a.state_province_id=b.state_province_id JOIN country c ON a.country_id=c.country_id WHERE name_type='original from geonames') b
WHERE a.country=b.country
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.max_sim=p.similarity
WHERE q.max_sim>0.75
) AS fzy
WHERE a.state_province_verbatim=fzy.state_province_verbatim
AND a.country=fzy.country
AND a.state_province IS NULL
;


