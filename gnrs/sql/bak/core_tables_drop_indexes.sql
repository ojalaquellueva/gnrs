-- user_data
DROP INDEX IF EXISTS user_data_poldiv_full_idx;
DROP INDEX IF EXISTS user_data_country_verbatim_idx;
DROP INDEX IF EXISTS user_data_state_province_verbatim_idx;
DROP INDEX IF EXISTS user_data_county_parish_verbatim_idx;
DROP INDEX IF EXISTS user_data_country_idx;
DROP INDEX IF EXISTS user_data_state_province_idx;
DROP INDEX IF EXISTS user_data_county_parish_idx;
DROP INDEX IF EXISTS user_data_country_id_idx;
DROP INDEX IF EXISTS user_data_state_province_id_idx;
DROP INDEX IF EXISTS user_data_county_parish_id_idx;
DROP INDEX IF EXISTS user_data_match_method_country_idx;
DROP INDEX IF EXISTS user_data_match_method_state_province_idx;
DROP INDEX IF EXISTS user_data_match_method_county_parish_idx;
DROP INDEX IF EXISTS user_data_poldiv_submitted_idx;
DROP INDEX IF EXISTS user_data_poldiv_matched_idx;
DROP INDEX IF EXISTS user_data_match_status_idx;
DROP INDEX IF EXISTS user_data_user_id_idx;

-- cache
DROP INDEX IF EXISTS cache_poldiv_full_idx;
DROP INDEX IF EXISTS cache_country_verbatim_idx;
DROP INDEX IF EXISTS cache_state_province_verbatim_idx;
DROP INDEX IF EXISTS cache_county_parish_verbatim_idx;
DROP INDEX IF EXISTS cache_country_idx;
DROP INDEX IF EXISTS cache_state_province_idx;
DROP INDEX IF EXISTS cache_county_parish_idx;
DROP INDEX IF EXISTS cache_country_id_idx;
DROP INDEX IF EXISTS cache_state_province_id_idx;
DROP INDEX IF EXISTS cache_county_parish_id_idx;
DROP INDEX IF EXISTS cache_match_method_country_idx;
DROP INDEX IF EXISTS cache_match_method_state_province_idx;
DROP INDEX IF EXISTS cache_match_method_county_parish_idx;
DROP INDEX IF EXISTS cache_poldiv_submitted_idx;
DROP INDEX IF EXISTS cache_poldiv_matched_idx;
DROP INDEX IF EXISTS cache_match_status_idx;