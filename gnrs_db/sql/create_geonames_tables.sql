DROP TABLE IF EXISTS "countryinfo";
CREATE TABLE "countryinfo" (
iso_alpha2 char(2) PRIMARY KEY,
iso_alpha3 char(3),
iso_numeric integer,
fips_code character varying(3),
country character varying(200),
capital character varying(200),
areainsqkm double precision,
population integer,
continent char(2),
tld char(10),
currency_code char(3),
currency_name char(15),
phone character varying(20),
postal character varying(60),
postalRegex character varying(200),
languages character varying(200),
geonameid int,
neighbours character varying(50),
equivalent_fips_code character varying(3)
);

DROP TABLE IF EXISTS geoname;
CREATE TABLE geoname (
geonameid int PRIMARY KEY,
name varchar(200),
asciiname varchar(200),
alternatenames varchar(8000),
latitude float,
longitude float,
fclass char(1),
fcode varchar(10),
country varchar(2) REFERENCES countryinfo,
cc2 varchar(60),
admin1 varchar(20),
admin2 varchar(80),
admin3 varchar(20),
admin4 varchar(20),
population bigint,
elevation int,
gtopo30 int,
timezone varchar(40),
moddate date
);

DROP TABLE IF EXISTS alternatename;
CREATE TABLE alternatename (
alternatenameId int PRIMARY KEY,
geonameid int REFERENCES geoname,
isoLanguage varchar(7),
alternateName varchar(300),
isPreferredName boolean,
isShortName boolean,
isColloquial boolean,
isHistoric boolean
);

DROP TABLE IF EXISTS iso_languagecodes;
CREATE TABLE iso_languagecodes(
iso_639_3 char(4),
iso_639_2 varchar(50),
iso_639_1 varchar(50),
language_name varchar(200)
);

DROP TABLE IF EXISTS admin1CodesAscii;
CREATE TABLE admin1CodesAscii (
code char(20),
name TEXT,
nameAscii TEXT,
geonameid int
);

DROP TABLE IF EXISTS admin2CodesAscii;
CREATE TABLE admin2CodesAscii (
code char(80),
name TEXT,
nameAscii TEXT,
geonameid int
);

DROP TABLE IF EXISTS featureCodes;
CREATE TABLE featureCodes (
code char(7),
name varchar(200),
description TEXT
);

DROP TABLE IF EXISTS timeZones;
CREATE TABLE timeZones (
countrycode char(2),
timeZoneId varchar(200),
GMT_offset numeric(3,1),
DST_offset numeric(3,1),
raw_offset numeric(3,1)
);

DROP TABLE IF EXISTS continentCodes;
CREATE TABLE continentCodes (
code char(2),
name varchar(20),
geonameid INT
);
