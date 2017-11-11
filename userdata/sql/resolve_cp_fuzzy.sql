-- ------------------------------------------------------------
--  Resolve county_parish
-- ------------------------------------------------------------

-- standard name
UPDATE user_data a
SET 
county_parish_id=fzy.county_parish_id,
county_parish=fzy.county_parish_std,
match_method_county_parish='fuzzy standard name',
match_score_county_parish=fzy.similarity
FROM 
(
SELECT
q.county_parish_verbatim,
p.country_id,
p.state_province_id,
p.county_parish_id,
p.county_parish_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_id,
county_parish_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_id,
a.county_parish_verbatim,
similarity(a.county_parish_verbatim,b.county_parish) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE country_id IS NOT NULL AND county_parish_id IS NULL
) a,
(SELECT a.country_id, b.county_parish FROM country a JOIN county_parish b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, state_province_id, county_parish_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.county_parish_verbatim,
b.county_parish_id,
b.county_parish,
b.county_parish_std,
similarity(a.county_parish_verbatim,b.county_parish) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE country_id IS NOT NULL AND county_parish_id IS NULL
) a,
(SELECT a.country_id, b.county_parish_id, b.county_parish, b.county_parish_std FROM country a JOIN county_parish b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) p
ON q.county_parish_verbatim=p.county_parish_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim>0.75
) AS fzy
WHERE a.county_parish_verbatim=fzy.county_parish_verbatim
AND a.country_id=fzy.country_id
AND a.county_parish IS NULL
;

-- standard ascii name
UPDATE user_data a
SET 
county_parish_id=fzy.county_parish_id,
county_parish=fzy.county_parish_std,
match_method_county_parish='fuzzy ascii name',
match_score_county_parish=fzy.similarity
FROM 
(
SELECT
q.county_parish_verbatim,
p.country_id,
p.county_parish_id,
p.county_parish_std,
p.similarity
FROM 
(
SELECT
country_id,
county_parish_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.county_parish_verbatim,
similarity(a.county_parish_verbatim,b.county_parish_ascii) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE country_id IS NOT NULL AND county_parish_id IS NULL
) a,
(SELECT a.country_id, b.county_parish_id, b.county_parish_ascii FROM country a JOIN county_parish b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, county_parish_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.county_parish_verbatim,
b.county_parish_id,
b.county_parish_std,
similarity(a.county_parish_verbatim,b.county_parish_ascii) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE country_id IS NOT NULL AND county_parish_id IS NULL
) a,
(SELECT a.country_id, b.county_parish_id, b.county_parish_ascii, b.county_parish_std FROM country a JOIN county_parish b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) p
ON q.county_parish_verbatim=p.county_parish_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim>0.75
) AS fzy
WHERE a.county_parish_verbatim=fzy.county_parish_verbatim
AND a.country_id=fzy.country_id
AND a.county_parish IS NULL
;

-- short ascii name
UPDATE user_data a
SET 
county_parish_id=fzy.county_parish_id,
county_parish=fzy.county_parish_std,
match_method_county_parish='fuzzy ascii short name',
match_score_county_parish=fzy.similarity
FROM 
(
SELECT
q.county_parish_verbatim,
p.country_id,
p.county_parish_id,
p.county_parish_std,
p.similarity
FROM 
(
SELECT
country_id,
county_parish_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.county_parish_verbatim,
similarity(a.county_parish_verbatim,b.county_parish_std) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE country_id IS NOT NULL AND county_parish_id IS NULL
) a,
(SELECT a.country_id, b.county_parish_id, b.county_parish_std FROM country a JOIN county_parish b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, county_parish_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.county_parish_verbatim,
b.county_parish_id,
b.county_parish_std,
similarity(a.county_parish_verbatim,b.county_parish_std) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE country_id IS NOT NULL AND county_parish_id IS NULL
) a,
(SELECT a.country_id, b.county_parish_id, b.county_parish_std FROM country a JOIN county_parish b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) p
ON q.county_parish_verbatim=p.county_parish_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim>0.75
) AS fzy
WHERE a.county_parish_verbatim=fzy.county_parish_verbatim
AND a.country_id=fzy.country_id
AND a.county_parish IS NULL
;

-- alternate name
UPDATE user_data a
SET 
county_parish_id=fzy.county_parish_id,
county_parish=fzy.county_parish_std,
match_method_county_parish='fuzzy alternate name',
match_score_county_parish=fzy.similarity
FROM 
(
SELECT
q.county_parish_verbatim,
p.country_id,
p.county_parish_id,
p.county_parish_std,
p.similarity
FROM 
(
SELECT
country_id,
county_parish_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.county_parish_verbatim,
b.county_parish_std,
similarity(a.county_parish_verbatim,b.county_parish_name) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE country_id IS NOT NULL AND county_parish_id IS NULL
) a,
(SELECT c.country_id, a.county_parish_id, county_parish_std, county_parish_name FROM county_parish a JOIN county_parish_name b ON a.county_parish_id=b.county_parish_id JOIN country c ON a.country_id=c.country_id WHERE name_type='original from geonames') b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, county_parish_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.county_parish_verbatim,
b.county_parish_id,
b.county_parish_std,
similarity(a.county_parish_verbatim,b.county_parish_name) AS similarity
FROM (
SELECT DISTINCT country_id, county_parish_verbatim
FROM user_data
WHERE country IS NOT NULL AND county_parish IS NULL
) a,
(SELECT c.country_id, a.county_parish_id, county_parish_std, county_parish_name FROM county_parish a JOIN county_parish_name b ON a.county_parish_id=b.county_parish_id JOIN country c ON a.country_id=c.country_id WHERE name_type='original from geonames') b
WHERE a.country_id=b.country_id
) p
ON q.county_parish_verbatim=p.county_parish_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim>0.75
) AS fzy
WHERE a.county_parish_verbatim=fzy.county_parish_verbatim
AND a.country_id=fzy.country_id
AND a.county_parish IS NULL
;