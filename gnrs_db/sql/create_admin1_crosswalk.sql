DROP TABLE IF EXISTS admin1_crosswalk;
CREATE TABLE admin1_crosswalk AS
SELECT DISTINCT
admin,
adm0_a3,
iso_a2,
name,
type,
type_en,
adm1_code,
iso_3166_2,
code_hasc,
fips,
fips_alt,
code_local,
abbrev,
postal,
gn_id,
gns_name,
gns_adm1,
gn_a1_code
FROM admin1_crosswalk_raw
ORDER BY admin, name
;

CREATE INDEX admin1_crosswalk_admin_idx ON admin1_crosswalk(admin);
CREATE INDEX admin1_crosswalk_adm0_a3_idx ON admin1_crosswalk(adm0_a3);
CREATE INDEX admin1_crosswalk_iso_a2_idx ON admin1_crosswalk(iso_a2);
CREATE INDEX admin1_crosswalk_name_idx ON admin1_crosswalk(name);
CREATE INDEX admin1_crosswalk_type_idx ON admin1_crosswalk(type);
CREATE INDEX admin1_crosswalk_type_en_idx ON admin1_crosswalk(type_en);
CREATE INDEX admin1_crosswalk_adm1_code_idx ON admin1_crosswalk(adm1_code);
CREATE INDEX admin1_crosswalk_iso_3166_2_idx ON admin1_crosswalk(iso_3166_2);
CREATE INDEX admin1_crosswalk_code_hasc_idx ON admin1_crosswalk(code_hasc);
CREATE INDEX admin1_crosswalk_fips_idx ON admin1_crosswalk(fips);
CREATE INDEX admin1_crosswalk_gn_id_idx ON admin1_crosswalk(gn_id);
CREATE INDEX admin1_crosswalk_gns_name_idx ON admin1_crosswalk(gns_name);
CREATE INDEX admin1_crosswalk_gns_adm1_idx ON admin1_crosswalk(gns_adm1);
CREATE INDEX admin1_crosswalk_gn_a1_code_idx ON admin1_crosswalk(gn_a1_code);
