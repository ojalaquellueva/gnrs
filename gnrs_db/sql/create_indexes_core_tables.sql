-- -----------------------------------------------------------------
-- Create indexes on core gnrs tables (excluding political division tables)
-- -----------------------------------------------------------------

--
-- user_data_raw
--

-- Drop first just in case
DROP INDEX IF EXISTS user_data_raw_job_idx;

-- Create indexes
CREATE INDEX user_data_raw_job_idx ON user_data_raw(job);

--
-- user_data
--

-- Drop first just in case
DROP INDEX IF EXISTS user_data_job_idx;
DROP INDEX IF EXISTS user_data_poldiv_full_idx;
DROP INDEX IF EXISTS user_data_country_verbatim_id;
DROP INDEX IF EXISTS user_data_state_province_verbatim_idx;
DROP INDEX IF EXISTS user_data_state_province_verbatim_alt_idx;
DROP INDEX IF EXISTS user_data_county_parish_verbatim_idx;
DROP INDEX IF EXISTS user_data_county_parish_verbatim_alt_idx;
DROP INDEX IF EXISTS user_data_country_id_idx;
DROP INDEX IF EXISTS user_data_state_province_id_idx;
DROP INDEX IF EXISTS user_data_county_parish_id_idx;
DROP INDEX IF EXISTS user_data_match_status_idx;

-- Create indexes
CREATE INDEX user_data_job_idx ON user_data(job);
CREATE INDEX user_data_poldiv_full_idx ON user_data(poldiv_full);
CREATE INDEX user_data_country_verbatim_idx ON user_data(country_verbatim);
CREATE INDEX user_data_state_province_verbatim_idx ON user_data(state_province_verbatim);
CREATE INDEX user_data_state_province_verbatim_alt_idx ON user_data(state_province_verbatim_alt);
CREATE INDEX user_data_county_parish_verbatim_idx ON user_data(county_parish_verbatim);
CREATE INDEX user_data_county_parish_verbatim_alt_idx ON user_data(county_parish_verbatim_alt);
CREATE INDEX user_data_country_id_idx ON user_data(country_id);
CREATE INDEX user_data_state_province_id_idx ON user_data(state_province_id);
CREATE INDEX user_data_county_parish_id_idx ON user_data(county_parish_id);
CREATE INDEX user_data_match_status_idx ON user_data(match_status);

--
-- cache
--

-- Drop first just in case
DROP INDEX IF EXISTS cache_poldiv_full_idx;

-- Create indexes
CREATE INDEX cache_poldiv_full_idx ON cache(poldiv_full);
