-- ------------------------------------------------------------
--  Resolve country
-- ------------------------------------------------------------

-- Index only as needed
DROP INDEX IF EXISTS user_data_match_status_isnull_idx;
CREATE INDEX IF NOT EXISTS user_data_match_status_isnull_idx ON user_data (match_status) WHERE match_status IS NULL;
DROP INDEX IF EXISTS user_data_country_verbatim_idx;
CREATE INDEX IF NOT EXISTS user_data_country_verbatim_idx ON user_data (country_verbatim);
DROP INDEX IF EXISTS user_data_country_id_isnull_idx;
CREATE INDEX IF NOT EXISTS user_data_country_id_isnull_idx ON user_data (country_id) WHERE country_id IS NULL;

-- standard name
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='exact standard name'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim=b.country
;

-- standard name
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='exact ascii name'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND unaccent(a.country_verbatim)=b.country
;

-- iso code
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='iso code'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim=b.iso
;

-- iso_alpha3 code
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='iso_alpha3 code'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim=b.iso_alpha3
;

-- fips code
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='fips code'
FROM country b
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim=b.iso_alpha3
;

-- Exact alternate name
UPDATE user_data a
SET 
country_id=b.country_id,
country=b.country,
match_method_country='exact alternate name'
FROM country b JOIN country_name c
ON b.country_id=c.country_id
WHERE job=:'job'
AND a.country_id IS NULL AND match_status IS NULL
AND a.country_verbatim=c.country_name
AND c.name_type='original from geonames'
;