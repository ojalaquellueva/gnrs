-- ---------------------------------------------------------------
-- Fixes admincodes tables, which are currently useless as they do 
-- not include iso codes
-- ---------------------------------------------------------------

-- 
-- Add full admincodes codes to table postalcodes 
-- 

-- Drop the indexes on postalcodes
DROP INDEX postalcodes_countrycode_idx;
DROP INDEX postalcodes_admin1name_idx;
DROP INDEX postalcodes_admin1code_idx;
DROP INDEX postalcodes_admin2name_idx;
DROP INDEX postalcodes_admin2code_idx;
DROP INDEX postalcodes_admin3name_idx;
DROP INDEX postalcodes_admin3code_idx;

ALTER TABLE postalcodes
ADD COLUMN admin1code_full VARCHAR(50) DEFAULT NULL,
ADD COLUMN admin2code_full VARCHAR(50) DEFAULT NULL,
ADD COLUMN admin3code_full VARCHAR(50) DEFAULT NULL,
ADD COLUMN admin1nameascii VARCHAR(50) DEFAULT NULL,
ADD COLUMN admin2nameascii VARCHAR(50) DEFAULT NULL,
ADD COLUMN admin3nameascii VARCHAR(50) DEFAULT NULL
;

UPDATE postalcodes
SET admin1nameascii=unaccent(admin1name),
admin2nameascii=unaccent(admin2name),
admin3nameascii=unaccent(admin3name)
;

UPDATE postalcodes
SET admin1code_full=CONCAT_WS('.',countrycode,admin1code)
WHERE admin1code IS NOT NULL
;

CREATE INDEX postalcodes_admin2code_notnull_idx ON postalcodes USING btree (admin2code) WHERE admin2code IS NOT NULL;
UPDATE postalcodes
SET admin2code_full=CONCAT_WS('.',countrycode,admin1code,admin2code)
WHERE admin1code IS NOT NULL AND admin2code IS NOT NULL
;

CREATE INDEX postalcodes_admin3code_notnull_idx ON postalcodes USING btree (admin3code) WHERE admin3code IS NOT NULL;
UPDATE postalcodes
SET admin3code_full=CONCAT_WS('.',countrycode,admin1code,admin2code,admin3code)
WHERE admin1code IS NOT NULL AND admin2code IS NOT NULL AND admin3code IS NOT NULL
;

-- Drop the temporary indexes
DROP INDEX postalcodes_admin1code_notnull_idx;
DROP INDEX postalcodes_admin2code_notnull_idx;
DROP INDEX postalcodes_admin3code_notnull_idx;

-- Recreate previous indexes, plus indexes for new columns
CREATE INDEX postalcodes_countrycode_idx ON postalcodes USING btree (countrycode);
CREATE INDEX postalcodes_admin1name_idx ON postalcodes USING btree (admin1name);
CREATE INDEX postalcodes_admin1code_idx ON postalcodes USING btree (admin1code);
CREATE INDEX postalcodes_admin2name_idx ON postalcodes USING btree (admin2name);
CREATE INDEX postalcodes_admin2code_idx ON postalcodes USING btree (admin2code);
CREATE INDEX postalcodes_admin3name_idx ON postalcodes USING btree (admin3name);
CREATE INDEX postalcodes_admin3code_idx ON postalcodes USING btree (admin3code);

CREATE INDEX postalcodes_admin1code_full_idx ON postalcodes USING btree (admin1code_full);
CREATE INDEX postalcodes_admin2code_full_idx ON postalcodes USING btree (admin2code_full);
CREATE INDEX postalcodes_admin3code_full_idx ON postalcodes USING btree (admin3code_full);

CREATE INDEX postalcodes_admin1nameascii_idx ON postalcodes USING btree (admin1nameascii);
CREATE INDEX postalcodes_admin2nameascii_idx ON postalcodes USING btree (admin2nameascii);
CREATE INDEX postalcodes_admin3nameascii_idx ON postalcodes USING btree (admin3nameascii);


--
-- Fix errors in existing admin codes tables
-- 
UPDATE admin1codesascii
SET name=nameascii
WHERE name is null and nameascii is not null
;

-- 
-- Add country codes to existing admin codes tables
-- 
ALTER TABLE admin1codesascii
ADD COLUMN countrycode VARCHAR(25) DEFAULT NULL;
UPDATE admin1codesascii 
SET countrycode=LEFT(code,2)
;
CREATE INDEX admin1codesascii_countrycode_idx ON admin1codesascii USING btree (countrycode);
CREATE INDEX admin1codesascii_name_idx ON admin1codesascii USING btree (name);
CREATE INDEX admin1codesascii_nameascii_idx ON admin1codesascii USING btree (nameascii);
CREATE INDEX admin1codesascii_code_idx ON admin1codesascii USING btree (code);

ALTER TABLE admin2codesascii
ADD COLUMN countrycode VARCHAR(25) DEFAULT NULL;
UPDATE admin2codesascii 
SET countrycode=LEFT(code,2)
;
CREATE INDEX admin2codesascii_countrycode_idx ON admin2codesascii USING btree (countrycode);
CREATE INDEX admin2codesascii_name_idx ON admin2codesascii USING btree (name);
CREATE INDEX admin2codesascii_nameascii_idx ON admin2codesascii USING btree (nameascii);
CREATE INDEX admin2codesascii_code_idx ON admin2codesascii USING btree (code);

