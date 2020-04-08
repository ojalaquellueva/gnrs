-- Drop indexes first just in case
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

-- Build the indexes
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
