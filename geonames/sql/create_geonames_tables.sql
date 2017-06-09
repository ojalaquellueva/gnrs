-- 
-- creates geonames tables without constraints or indexes
--

DROP TABLE IF EXISTS geoname CASCADE;
CREATE TABLE geoname (
    geonameid      INT,
    name           VARCHAR(200),
    asciiname      VARCHAR(200),
    alternatenames TEXT,
    latitude       FLOAT,
    longitude      FLOAT,
    fclass         CHAR(1),
    fcode          VARCHAR(10),
    country        VARCHAR(2),
    cc2            TEXT,
    admin1         VARCHAR(20),
    admin2         VARCHAR(80),
    admin3         VARCHAR(20),
    admin4         VARCHAR(20),
    population     BIGINT,
    elevation      INT,
    gtopo30        INT,
    timezone       VARCHAR(40),
    moddate        DATE
);

DROP TABLE IF EXISTS alternatename;
CREATE TABLE alternatename (
    alternatenameid INT,
    geonameid       INT,
    isoLanguage     VARCHAR(7),
    alternatename   VARCHAR(500),
	ispreferredname BOOLEAN,
	isshortname BOOLEAN,
	iscolloquial BOOLEAN,
	ishistoric BOOLEAN
);

DROP TABLE IF EXISTS countryinfo;
CREATE TABLE countryinfo (
    iso_alpha2           CHAR(2),
    iso_alpha3           CHAR(3),
    iso_numeric          INTEGER,
    fips_code            CHARACTER VARYING(3),
    country              CHARACTER VARYING(200),
    capital              CHARACTER VARYING(200),
    areainsqkm           DOUBLE PRECISION,
    population           INTEGER,
    continent            CHAR(2),
    tld                  CHAR(10),
    currency_code        CHAR(3),
    currency_name        CHAR(15),
    phone                CHARACTER VARYING(20),
    postal               CHARACTER VARYING(60),
    postalregex          CHARACTER VARYING(200),
    languages            CHARACTER VARYING(200),
    geonameid            INT,
    neighbours           CHARACTER VARYING(50),
    equivalent_fips_code CHARACTER VARYING(3)
);

DROP TABLE IF EXISTS iso_languagecodes;
CREATE TABLE iso_languagecodes(
    iso_639_3     CHAR(4),
    iso_639_2     VARCHAR(50),
    iso_639_1     VARCHAR(50),
    language_name VARCHAR(200)
);

DROP TABLE IF EXISTS admin1codesascii;
CREATE TABLE admin1codesascii (
    code      CHAR(20),
    name      TEXT,
    nameascii TEXT,
    geonameid INT
);

DROP TABLE IF EXISTS admin2codesascii;
CREATE TABLE admin2codesascii (
    code      CHAR(80),
    name      TEXT,
    nameascii TEXT,
    geonameid INT
);

DROP TABLE IF EXISTS featurecodes;
CREATE TABLE featurecodes (
    code        CHAR(7),
    name        VARCHAR(200),
    description TEXT
);

DROP TABLE IF EXISTS timezones;
CREATE TABLE timezones (
	countrycode CHAR(20),
    timezoneid VARCHAR(200),
    gmt_offset NUMERIC(3,1),
    dst_offset NUMERIC(3,1),
    raw_offset NUMERIC(3,1)
);

DROP TABLE IF EXISTS continentcodes;
CREATE TABLE continentcodes (
    code      CHAR(2),
    name      VARCHAR(20),
    geonameid INT
);
