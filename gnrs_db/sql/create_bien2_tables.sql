DROP TABLE IF EXISTS state_province_bien2;
CREATE TABLE state_province_bien2 (
state_province_id INTEGER NOT NULL PRIMARY KEY,
country_iso TEXT DEFAULT NULL,
state_province_std TEXT DEFAULT NULL,
state_province_iso TEXT DEFAULT NULL,
state_province_code_unique TEXT DEFAULT NULL,
bien2_1 TEXT DEFAULT NULL
);

CREATE INDEX ON state_province_bien2 (country_iso);
CREATE INDEX ON state_province_bien2 (state_province_std);
CREATE INDEX ON state_province_bien2 (country_iso);
CREATE INDEX ON state_province_bien2 (state_province_iso);

DROP TABLE IF EXISTS county_parish_bien2;
CREATE TABLE county_parish_bien2 (
countyParishID INTEGER NOT NULL PRIMARY KEY,
stateProvinceID INTEGER DEFAULT NULL,
stateProvinceUniqueCode TEXT DEFAULT NULL,
countyParishStd TEXT DEFAULT NULL, 
countyParishUniqueCode TEXT DEFAULT NULL,
HASC_2 TEXT DEFAULT NULL,
poldivType_eng TEXT DEFAULT NULL
);

CREATE INDEX ON county_parish_bien2 (stateProvinceID);
CREATE INDEX ON county_parish_bien2 (countyParishStd);

