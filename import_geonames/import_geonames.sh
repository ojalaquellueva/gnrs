#!/bin/bash
#===============================================================================
# FILE: import_geonames.sh
#
# USAGE: sudo -u postgres import_geonames.sh [/path/to/working/directory]
#
# DESCRIPTION: run the script so that the geodata will be downloaded and
# inserted into your database
#
# SOURCE: https://gist.github.com/bbinet/3635232
#
# ORIGINAL AUTHOR: Andreas (aka Harpagophyt)
# URL: http://forum.geonames.org/gforum/posts/list/15/926.page
# VERSION: 1.5 (modified)
# CREATED: 07/06/2008
# REVISION:
# 1.1 2008-06-07 replace COPY continentCodes through INSERT statements.
# 1.2 2008-11-25 Adjusted by Bastiaan Wakkie in order to not unnessisarily
# download.
# 1.3 2011-08-07 Updated script with tree changes. Removes 2 obsolete records
# from "countryinfo" dump image, updated timeZones table with raw_offset and
# updated postalcode to varchar(20).
# 1.4 2012-03-31 Don Drake  - Add FKs after data is loaded, also vacuum analyze
# tables to ensure FK lookups use PK - Don't unzip text files - added DROP
# TABLE IF EXISTS
# 1.5 2012-06-30 Furdui Marian - added CountryCode to TimeZones and updated
# geonames.alternatenames to varchar(8000)
#===============================================================================

source "params.sh"

if [ -d "$1" ]; then
    WORKPATH="$1"
fi
mkdir -p "$WORKPATH"
RETVAL=$?
[ $RETVAL -ne 0 ] && echo "Can't create $WORKPATH directory: Aborting." && exit $RETVAL

psql -c "CREATE DATABASE geonames WITH TEMPLATE = template0 ENCODING = 'UTF8';"
RETVAL=$?
[ $RETVAL -ne 0 ] && echo "A database named 'geonames' already exists: Aborting." && exit $RETVAL

psql geonames <<EOT
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
CREATE TABLE geoname (
geonameid int PRIMARY KEY,
name varchar(200),
asciiname varchar(200),
alternatenames text,
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
CREATE TABLE iso_languagecodes(
iso_639_3 char(4),
iso_639_2 varchar(50),
iso_639_1 varchar(50),
language_name varchar(200)
);
CREATE TABLE admin1CodesAscii (
code char(20),
name TEXT,
nameAscii TEXT,
geonameid int
);
CREATE TABLE admin2CodesAscii (
code char(80),
name TEXT,
nameAscii TEXT,
geonameid int
);
CREATE TABLE featureCodes (
code char(7),
name varchar(200),
description TEXT
);
CREATE TABLE timeZones (
countrycode char(2),
timeZoneId varchar(200),
GMT_offset numeric(3,1),
DST_offset numeric(3,1),
raw_offset numeric(3,1)
);
CREATE TABLE continentCodes (
code char(2),
name varchar(20),
geonameid INT
);
EOT
RETVAL=$?
[ $RETVAL -ne 0 ] && echo "Cannot create 'geonames' database schema: Aborting." && exit $RETVAL

echo ",---- STARTING (downloading, unpacking and preparing)"
cd "$WORKPATH"
echo "Files will be downloaded in $(pwd) directory"
for i in $FILES
do
    wget -N -q "http://download.geonames.org/export/dump/$i" # get newer files
    RETVAL=$?
    [ $RETVAL -ne 0 ] && echo "Cannot download $i file: Aborting. Error="$RETVAL && exit $RETVAL
    if [ $i -nt "_$i" ] || [ ! -e "_$i" ] ; then
        cp -p $i "_$i"
        if [ `expr index zip $i` -eq 1 ]; then
            unzip -o -u -q $i
        fi
        case "$i" in
            iso-languagecodes.txt)
                tail -n +2 iso-languagecodes.txt > iso-languagecodes.txt.tmp;
            ;;
            countryInfo.txt)
                grep -v '^#' countryInfo.txt | head -n -2 > countryInfo.txt.tmp;
            ;;
            timeZones.txt)
                tail -n +2 timeZones.txt > timeZones.txt.tmp;
            ;;
        esac
        echo "| $i has been downloaded";
    else
        echo "| $i is already the latest version"
    fi
done

echo "+---- FILL DATABASE"
PWD=$(pwd)
psql -e geonames <<EOT
copy countryinfo (iso_alpha2,iso_alpha3,iso_numeric,fips_code,country,capital,areainsqkm,population,continent,tld,currency_code,currency_name,phone,postal,postalRegex,languages,geonameid,neighbours,equivalent_fips_code) from '${PWD}/countryInfo.txt.tmp' null as '';
vacuum analyze verbose countryinfo;
copy geoname (geonameid,name,asciiname,alternatenames,latitude,longitude,fclass,fcode,country,cc2,admin1,admin2,admin3,admin4,population,elevation,gtopo30,timezone,moddate) from '${PWD}/allCountries.txt' null as '';
ALTER TABLE ONLY countryinfo
ADD CONSTRAINT fk_geonameid FOREIGN KEY (geonameid) REFERENCES geoname(geonameid);
vacuum analyze verbose geoname;
copy timeZones (countrycode,timeZoneId,GMT_offset,DST_offset,raw_offset) from '${PWD}/timeZones.txt.tmp' null as '';
vacuum analyze verbose timeZones;
copy featureCodes (code,name,description) from '${PWD}/featureCodes_en.txt' null as '';
vacuum analyze verbose featureCodes;
copy admin1CodesAscii (code,name,nameAscii,geonameid) from '${PWD}/admin1CodesASCII.txt' null as '';
vacuum analyze verbose admin1CodesAscii;
copy admin2CodesAscii (code,name,nameAscii,geonameid) from '${PWD}/admin2Codes.txt' null as '';
vacuum analyze verbose admin2CodesAscii;
copy iso_languagecodes (iso_639_3,iso_639_2,iso_639_1,language_name) from '${PWD}/iso-languagecodes.txt.tmp' null as '';
vacuum analyze verbose iso_languagecodes;
copy alternatename (alternatenameid,geonameid,isoLanguage,alternateName,isPreferredName,isShortName,isColloquial,isHistoric) from '${PWD}/alternateNames.txt' null as '';
vacuum analyze verbose alternatename;
INSERT INTO continentCodes VALUES ('AF', 'Africa', 6255146);
INSERT INTO continentCodes VALUES ('AS', 'Asia', 6255147);
INSERT INTO continentCodes VALUES ('EU', 'Europe', 6255148);
INSERT INTO continentCodes VALUES ('NA', 'North America', 6255149);
INSERT INTO continentCodes VALUES ('OC', 'Oceania', 6255150);
INSERT INTO continentCodes VALUES ('SA', 'South America', 6255151);
INSERT INTO continentCodes VALUES ('AN', 'Antarctica', 6255152);
vacuum analyze verbose continentCodes;
CREATE INDEX index_countryinfo_geonameid ON countryinfo USING hash (geonameid);
CREATE INDEX index_alternatename_geonameid ON alternatename USING hash (geonameid);
EOT
RETVAL=$?
[ $RETVAL -ne 0 ] && echo "An error occured while populating database: Aborting." && exit $RETVAL

echo "+---- ADD GEOMETRY COLUMN"
psql geonames <<EOT
CREATE EXTENSION postgis;
ALTER TABLE geoname ADD COLUMN
geom geometry(Point, 4326);
UPDATE geoname SET geom = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);
CREATE INDEX geoname_geom_gix ON geoname USING GIST ( geom );
EOT
RETVAL=$?
[ $RETVAL -ne 0 ] && echo "Cannot create 'geoname.geom' geometry column: Aborting." && exit $RETVAL

echo "+---- GRANT TO USER '$USER'"
psql geonames <<EOT
GRANT ALL ON SELECT TABLES IN SCHEMA public TO $USER;
GRANT ALL ON SELECT SEQUENCES IN SCHEMA public TO $USER;
EOT
RETVAL=$?
[ $RETVAL -ne 0 ] && echo "Cannot grant all rights to user '$USER': Aborting." && exit $RETVAL

echo "'----- DONE"
