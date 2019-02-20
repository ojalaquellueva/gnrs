-- user_data
CREATE INDEX user_data_job_idx ON user_data (job);
CREATE INDEX user_data_poldiv_full_idx ON user_data (poldiv_full);
CREATE INDEX user_data_country_verbatim_idx ON user_data (country_verbatim);
CREATE INDEX user_data_state_province_verbatim_idx ON user_data (state_province_verbatim);
CREATE INDEX user_data_county_parish_verbatim_idx ON user_data (county_parish_verbatim);
CREATE INDEX user_data_country_idx ON user_data (country);
CREATE INDEX user_data_state_province_idx ON user_data (state_province);
CREATE INDEX user_data_county_parish_idx ON user_data (county_parish);
CREATE INDEX user_data_country_id_idx ON user_data (country_id);
CREATE INDEX user_data_state_province_id_idx ON user_data (state_province_id);
CREATE INDEX user_data_county_parish_id_idx ON user_data (county_parish_id);
CREATE INDEX user_data_match_method_country_idx ON user_data (match_method_country);
CREATE INDEX user_data_match_method_state_province_idx ON user_data (match_method_state_province);
CREATE INDEX user_data_match_method_county_parish_idx ON user_data (match_method_county_parish);
CREATE INDEX user_data_poldiv_submitted_idx ON user_data (poldiv_submitted);
CREATE INDEX user_data_poldiv_matched_idx ON user_data (poldiv_matched);
CREATE INDEX user_data_match_status_idx ON user_data (match_status);
CREATE INDEX user_data_user_id_idx ON user_data (user_id);


-- cache
CREATE INDEX cache_poldiv_full_idx ON cache (poldiv_full);
CREATE INDEX cache_country_verbatim_idx ON cache (country_verbatim);
CREATE INDEX cache_state_province_verbatim_idx ON cache (state_province_verbatim);
CREATE INDEX cache_county_parish_verbatim_idx ON cache (county_parish_verbatim);
CREATE INDEX cache_country_idx ON cache (country);
CREATE INDEX cache_state_province_idx ON cache (state_province);
CREATE INDEX cache_county_parish_idx ON cache (county_parish);
CREATE INDEX cache_country_id_idx ON cache (country_id);
CREATE INDEX cache_state_province_id_idx ON cache (state_province_id);
CREATE INDEX cache_county_parish_id_idx ON cache (county_parish_id);
CREATE INDEX cache_match_method_country_idx ON cache (match_method_country);
CREATE INDEX cache_match_method_state_province_idx ON cache (match_method_state_province);
CREATE INDEX cache_match_method_county_parish_idx ON cache (match_method_county_parish);
CREATE INDEX cache_poldiv_submitted_idx ON cache (poldiv_submitted);
CREATE INDEX cache_poldiv_matched_idx ON cache (poldiv_matched);
CREATE INDEX cache_match_status_idx ON cache (match_status);
