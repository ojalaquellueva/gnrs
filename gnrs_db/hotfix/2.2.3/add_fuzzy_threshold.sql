-- -------------------------------------------------------------------
-- Add fuzzy match threshold column to table user_data, all databases
-- -------------------------------------------------------------------

-- Private development: db gnrs_dev on vegbiendev
\c gnrs_dev
alter table user_data
add column threshold_fuzzy NUMERIC(4,2) DEFAULT NULL;

drop index if exists user_data_threshold_fuzzy_idx;
create index user_data_threshold_fuzzy_idx ON user_data(threshold_fuzzy);

-- Public development: db gnrs_2_2 on vegbiendev
\c gnrs_2_2
alter table user_data
add column threshold_fuzzy NUMERIC(4,2) DEFAULT NULL;

drop index if exists user_data_threshold_fuzzy_idx;
create index user_data_threshold_fuzzy_idx ON user_data(threshold_fuzzy);

-- Production: db gnrs_2_2 on paramo
\c gnrs_2_2
alter table user_data
add column threshold_fuzzy NUMERIC(4,2) DEFAULT NULL;

drop index if exists user_data_threshold_fuzzy_idx;
create index user_data_threshold_fuzzy_idx ON user_data(threshold_fuzzy);
