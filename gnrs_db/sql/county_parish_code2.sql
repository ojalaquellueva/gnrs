-- -----------------------------------------------
-- Updates second set of codes from postal table
-- -----------------------------------------------


ALTER TABLE county_parish
ADD COLUMN state_province_code2 TEXT,
ADD COLUMN state_province_code2_full TEXT,
ADD COLUMN county_parish_code2 TEXT,
ADD COLUMN county_parish_code2_full TEXT;
;

UPDATE county_parish a 
SET state_province_code2=b.state_province_code2,
state_province_code2_full=b.state_province_code2_full
FROM state_province b
WHERE a.state_province_id=b.state_province_id
;

-- 
-- Verbatim admin2 name
--

-- Join by verbatim name
UPDATE county_parish a
SET county_parish_code2=b.admin2code,
county_parish_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code, b.admin2code)
FROM (
SELECT DISTINCT countrycode, admin1code, admin2name, admin2code
FROM postalcodes
) AS b 
WHERE a.country_iso=b.countrycode
AND a.state_province_code2=b.admin1code
AND b.admin2name=a.county_parish
AND county_parish_code2 IS NULL
;

-- Join by ascii name
UPDATE county_parish a
SET county_parish_code2=b.admin2code,
county_parish_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code, b.admin2code)
FROM (
SELECT DISTINCT countrycode, admin1code, admin2name, admin2code
FROM postalcodes
) AS b 
WHERE a.country_iso=b.countrycode
AND a.state_province_code2=b.admin1code
AND b.admin2name=a.county_parish_ascii
AND county_parish_code2 IS NULL
;

-- 
-- Plain ascii admin2 name
--

-- Join by verbatim name
UPDATE county_parish a
SET county_parish_code2=b.admin2code,
county_parish_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code, b.admin2code)
FROM (
SELECT DISTINCT countrycode, admin1code, admin2nameascii, admin2code
FROM postalcodes
) AS b 
WHERE a.country_iso=b.countrycode
AND a.state_province_code2=b.admin1code
AND b.admin2nameascii=a.county_parish
AND county_parish_code2 IS NULL
;

-- Join by ascii name
UPDATE county_parish a
SET county_parish_code2=b.admin2code,
county_parish_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code, b.admin2code)
FROM (
SELECT DISTINCT countrycode, admin1code, admin2nameascii, admin2code
FROM postalcodes
) AS b 
WHERE a.country_iso=b.countrycode
AND a.state_province_code2=b.admin1code
AND b.admin2nameascii=a.county_parish_ascii
AND county_parish_code2 IS NULL
;


-- 
-- by alt names
--

UPDATE county_parish a
SET county_parish_code2=b.admin2code,
county_parish_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code, b.admin2code)
FROM (
SELECT DISTINCT countrycode, admin1code, admin2name, admin2nameascii, admin2code
FROM postalcodes
) AS b 
JOIN county_parish_name c
ON b.admin2name=c.county_parish_name
WHERE a.country_iso=b.countrycode
AND a.state_province_code2=b.admin1code
AND b.admin2name=a.county_parish_ascii
AND county_parish_code2 IS NULL
;

UPDATE county_parish a
SET county_parish_code2=b.admin2code,
county_parish_code2_full=CONCAT_WS('.',b.countrycode, b.admin1code, b.admin2code)
FROM (
SELECT DISTINCT countrycode, admin1code, admin2name, admin2nameascii, admin2code
FROM postalcodes
) AS b 
JOIN county_parish_name c
ON b.admin2name=c.county_parish_name
WHERE a.country_iso=b.countrycode
AND a.state_province_code2=b.admin1code
AND b.admin2nameascii=a.county_parish_ascii
AND county_parish_code2 IS NULL
;

-- Fix erroneous codes
UPDATE county_parish
SET county_parish_code2_full=NULL
WHERE county_parish_code2 is null;

CREATE INDEX county_parish_state_province_code2_idx ON county_parish USING btree (state_province_code2);
CREATE INDEX county_parish_state_province_code2_full_idx ON county_parish USING btree (state_province_code2_full);
CREATE INDEX county_parish_county_parish_code2_idx ON county_parish USING btree (county_parish_code2);
CREATE INDEX county_parish_county_parish_code2_full_idx ON county_parish USING btree (county_parish_code2_full);


