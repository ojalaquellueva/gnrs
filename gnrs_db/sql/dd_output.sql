-- -----------------------------------------------------------------
-- Create data dictionary of GNRS output -----------------------------------------------------------------

DROP TABLE IF EXISTS dd_output;
CREATE TABLE dd_output (
col_name text not null primary key,
ordinal_position integer not null,
data_type text default null,
description text default null
);

INSERT INTO dd_output (col_name, ordinal_position, data_type, description)
VALUES 
('country_verbatim',1,'Text','Verbatim country, as submitted'),
('state_province_verbatim',2,'Text','Verbatim state/province, as submitted'),
('state_province_verbatim_alt',3,'Text','Verbatim state/province, stripped of class identifier (if applicable)'),
('county_parish_verbatim',4,'Text','Verbatim county, as submitted'),
('county_parish_verbatim_alt',5,'Text','Verbatim county, stripped of class identifier (if applicable)'),
('country',6,'Text','Resolved country name'),
('state_province',7,'Text','Resolved state/province name'),
('county_parish',8,'Text','Resolve county/parish name'),
('country_id',9,'Integer','GNRS identifier for country'),
('state_province_id',10,'Integer','GNRS identifier for state/province'),
('county_parish_id',11,'Integer','GNRS identifier for county/parish'),
('country_iso',12,'Text','Two-letter ISO code for country'),
('state_province_iso',13,'Text','Two-letter ISO code for state/province'),
('county_parish_iso',14,'Text','Two-letter ISO code for county/parish'),
('geonameid',15,'Integer','Geoname identifier of lowest resolved political division'),
('gid_0',16,'Text','GADM identifier of country'),
('gid_1',17,'Text','GADM identifier of state/province'),
('gid_2',18,'Text','GADM identifier of county/parish'),
('match_method_country',19,'Text','Method by which country was matched'),
('match_method_state_province',20,'Text','Method by which state/province was matched'),
('match_method_county_parish',21,'Text','Method by which county/parish was matched'),
('match_score_country',22,'Decimal (0:1)','Match score for country'),
('match_score_state_province',23,'Decimal (0:1)','Match score for state/province'),
('match_score_county_parish',24,'Decimal (0:1)','Match score for county/parish'),
('overall_score',25,'Decimal (0:1)','Overall match score'),
('poldiv_submitted',26,'Text','Lowest political division submitted'),
('poldiv_matched',27,'Text','Lowest political division matched'),
('match_status',28,'Text','Complete match, partial match, or no match?'),
('user_id',29,'Text','Optional user-supplied identifier')
;

DROP INDEX dd_output_col_name_idx;
CREATE INDEX dd_output_col_name_idx ON dd_output (col_name);





