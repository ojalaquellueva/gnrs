-- ----------------------------------------------------------------
-- Adds ISO code fields to existing GNRS database
-- Manual fix to bring up to date with latest revisions without 
-- having to rebuild database
-- ----------------------------------------------------------------


ALTER TABLE cache
ADD COLUMN country_iso VARCHAR(50)  DEFAULT NULL,
ADD COLUMN state_province_iso VARCHAR(50)  DEFAULT NULL,
ADD COLUMN county_parish_iso VARCHAR(50)  DEFAULT NULL
;

ALTER TABLE user_data
ADD COLUMN country_iso VARCHAR(50)  DEFAULT NULL,
ADD COLUMN state_province_iso VARCHAR(50)  DEFAULT NULL,
ADD COLUMN county_parish_iso VARCHAR(50)  DEFAULT NULL
;
