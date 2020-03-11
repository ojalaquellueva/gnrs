-- ------------------------------------------------------------
--  Resolve state_province
-- ------------------------------------------------------------

-- standard name
UPDATE user_data a
SET 
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy standard name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_verbatim,
similarity(a.state_province_verbatim,b.state_province) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_verbatim,
b.state_province_id,
b.state_province,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province_id, b.state_province, b.state_province_std FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim>:match_threshold
) AS fzy
WHERE job=:'job'
AND a.state_province_verbatim=fzy.state_province_verbatim
AND a.country_id=fzy.country_id
AND a.state_province IS NULL AND match_status IS NULL
;

-- standard ascii name
UPDATE user_data a
SET 
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy ascii name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_verbatim,
similarity(a.state_province_verbatim,b.state_province_ascii) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province_id, b.state_province_ascii FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_verbatim,
b.state_province_id,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province_ascii) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province_id, b.state_province_ascii, b.state_province_std FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim>:match_threshold
) AS fzy
WHERE job=:'job'
AND a.state_province_verbatim=fzy.state_province_verbatim
AND a.country_id=fzy.country_id
AND a.state_province IS NULL AND match_status IS NULL
;

-- short ascii name
UPDATE user_data a
SET 
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy ascii short name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_verbatim,
similarity(a.state_province_verbatim,b.state_province_std) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province_id, b.state_province_std FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_verbatim,
b.state_province_id,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province_std) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT a.country_id, b.state_province_id, b.state_province_std FROM country a JOIN state_province b ON a.country_id=b.country_id) b
WHERE a.country_id=b.country_id
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim>:match_threshold
) AS fzy
WHERE job=:'job'
AND a.state_province_verbatim=fzy.state_province_verbatim
AND a.country_id=fzy.country_id
AND a.state_province IS NULL AND match_status IS NULL
;

-- alternate name
UPDATE user_data a
SET 
state_province_id=fzy.state_province_id,
state_province=fzy.state_province_std,
match_method_state_province='fuzzy alternate name',
match_score_state_province=fzy.similarity
FROM 
(
SELECT
q.state_province_verbatim,
p.country_id,
p.state_province_id,
p.state_province_std,
p.similarity
FROM 
(
SELECT
country_id,
state_province_verbatim,
MAX(similarity) AS max_sim
FROM
(
SELECT 
a.country_id,
a.state_province_verbatim,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province_name) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT c.country_id, a.state_province_id, state_province_std, state_province_name FROM state_province a JOIN state_province_name b ON a.state_province_id=b.state_province_id JOIN country c ON a.country_id=c.country_id WHERE name_type='original from geonames') b
WHERE a.country_id=b.country_id
) x
GROUP BY country_id, state_province_verbatim
) q 
JOIN 
(
SELECT 
a.country_id,
a.state_province_verbatim,
b.state_province_id,
b.state_province_std,
similarity(a.state_province_verbatim,b.state_province_name) AS similarity
FROM (
SELECT DISTINCT country_id, state_province_verbatim
FROM user_data
WHERE job=:'job'
AND country_id IS NOT NULL AND state_province_id IS NULL
AND state_province_verbatim<>''
) a,
(SELECT c.country_id, a.state_province_id, state_province_std, state_province_name FROM state_province a JOIN state_province_name b ON a.state_province_id=b.state_province_id JOIN country c ON a.country_id=c.country_id WHERE name_type='original from geonames') b
WHERE a.country_id=b.country_id
) p
ON q.state_province_verbatim=p.state_province_verbatim
AND q.country_id=p.country_id
AND q.max_sim=p.similarity
WHERE q.max_sim>:match_threshold
) AS fzy
WHERE job=:'job'
AND a.state_province_verbatim=fzy.state_province_verbatim
AND a.country_id=fzy.country_id
AND a.state_province IS NULL AND match_status IS NULL
;