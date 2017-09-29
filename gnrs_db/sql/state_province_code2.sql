-- -----------------------------------------------
-- Updates second set of codes from postal table
-- -----------------------------------------------


ALTER TABLE state_province
ADD COLUMN state_province_code2 TEXT,
ADD COLUMN state_province_code2_full TEXT;
;

-- 
-- Verbatim admin1 name
--

-- Join by verbatim name
UPDATE state_province a
SET state_province_code2=b.admin1code,
state_province_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code)
FROM (
SELECT DISTINCT countrycode, admin1name, admin1code
FROM postalcodes
) AS b
WHERE a.country_iso=b.countrycode
AND b.admin1name=a.state_province
AND state_province_code2 IS NULL
;

-- Join by ascii name
UPDATE state_province a
SET state_province_code2=b.admin1code,
state_province_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code)
FROM (
SELECT DISTINCT countrycode, admin1name, admin1code
FROM postalcodes
) AS b
WHERE a.country_iso=b.countrycode
AND b.admin1name=a.state_province_ascii
AND state_province_code2 IS NULL
;

-- Join by plain name
UPDATE state_province a
SET state_province_code2=b.admin1code,
state_province_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code)
FROM (
SELECT DISTINCT countrycode, admin1name, admin1code
FROM postalcodes
) AS b
WHERE a.country_iso=b.countrycode
AND b.admin1name=a.state_province_std
AND state_province_code2 IS NULL
;

-- 
-- Plain ascii admin1 name
--

-- Join by verbatim name
UPDATE state_province a
SET state_province_code2=b.admin1code,
state_province_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code)
FROM (
SELECT DISTINCT countrycode, admin1nameascii, admin1code
FROM postalcodes
) AS b
WHERE a.country_iso=b.countrycode
AND b.admin1nameascii=a.state_province
AND state_province_code2 IS NULL
;

-- Join by ascii name
UPDATE state_province a
SET state_province_code2=b.admin1code,
state_province_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code)
FROM (
SELECT DISTINCT countrycode, admin1nameascii, admin1code
FROM postalcodes
) AS b
WHERE a.country_iso=b.countrycode
AND b.admin1nameascii=a.state_province_ascii
AND state_province_code2 IS NULL
;

-- Join by plain name
UPDATE state_province a
SET state_province_code2=b.admin1code,
state_province_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code)
FROM (
SELECT DISTINCT countrycode, admin1nameascii, admin1code
FROM postalcodes
) AS b
WHERE a.country_iso=b.countrycode
AND b.admin1nameascii=a.state_province_std
AND state_province_code2 IS NULL
;

-- 
-- by alt names
--

UPDATE state_province a
SET state_province_code2=b.admin1code,
state_province_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code)
FROM (
SELECT DISTINCT countrycode, admin1name, admin1code
FROM postalcodes 
) AS b
JOIN state_province_name c
ON b.admin1name=c.state_province_name
WHERE a.country_iso=b.countrycode
AND a.state_province_id=c.state_province_id
AND state_province_code2 IS NULL
;

UPDATE state_province a
SET state_province_code2=b.admin1code,
state_province_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code)
FROM (
SELECT DISTINCT countrycode, admin1nameascii, admin1code
FROM postalcodes 
) AS b
JOIN state_province_name c
ON b.admin1nameascii=c.state_province_name
WHERE a.country_iso=b.countrycode
AND a.state_province_id=c.state_province_id
AND state_province_code2 IS NULL
;

-- Fix erroneous codes
UPDATE state_province
SET state_province_code2_full=NULL
WHERE state_province_code2 is null;

