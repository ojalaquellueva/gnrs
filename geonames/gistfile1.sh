#!/bin/bash
#===============================================================================
#
# FILE: getgeo.sh
#
# USAGE: ./getgeo.sh
#
# DESCRIPTION: run the script so that the geodata will be downloaded and inserted into your
# database
#
# OPTIONS: ---
# REQUIREMENTS: ---
# BUGS: ---
# NOTES: ---
# AUTHOR: Andreas (aka Harpagophyt )
# COMPANY: <a href="http://forum.geonames.org/gforum/posts/list/926.page" target="_blank" rel="nofollow">http://forum.geonames.org/gforum/posts/list/926.page</a>
# VERSION: 1.3
# CREATED: 07/06/2008
# REVISION: 1.1 2008-06-07 replace COPY continentCodes through INSERT statements.
# 1.2 2008-11-25 Adjusted by Bastiaan Wakkie in order to not unnessisarily
# download.
# 1.3 2011-08-07 Updated script with tree changes. Removes 2 obsolete records from "countryinfo" dump image,
#                updated timeZones table with raw_offset and updated postalcode to varchar(20).
#===============================================================================
#!/bin/bash

# Set to f to skip download, else t
# "f" assumes files are already downloaded
download="f"

#WORKPATH="${HOME}/tmp/GIS/gisnames/geodata"
WORKPATH="/home/boyle/bien3/geonames/data"
TMPPATH="tmp"
PCPATH="pc"
PREFIX="_"
DBHOST="127.0.0.1"
DBPORT="5432"
DBUSER="postgres"
FILES="allCountries.zip alternateNames.zip userTags.zip admin1CodesASCII.txt admin2Codes.txt countryInfo.txt featureCodes_en.txt iso-languagecodes.txt timeZones.txt"

# Create the database
psql -c "CREATE DATABASE geonames WITH TEMPLATE = template0 ENCODING = 'UTF8';"
RETVAL=$?
[ $RETVAL -ne 0 ] && echo "A database named 'geonames' already exists: Aborting." && exit $RETVAL

psql geonames <<EOT
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
    alternatenameId INT,
    geonameid       INT,
    isoLanguage     VARCHAR(7),
    alternateName   VARCHAR(300),
    isPreferredName BOOLEAN,
    isShortName     BOOLEAN
);
DROP TABLE IF EXISTS countryinfo;
CREATE TABLE "countryinfo" (
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
    postalRegex          CHARACTER VARYING(200),
    languages            CHARACTER VARYING(200),
    geonameId            INT,
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
DROP TABLE IF EXISTS admin1CodesAscii;
CREATE TABLE admin1CodesAscii (
    code      CHAR(20),
    name      TEXT,
    nameAscii TEXT,
    geonameid INT
);
DROP TABLE IF EXISTS admin2CodesAscii;
CREATE TABLE admin2CodesAscii (
    code      CHAR(80),
    name      TEXT,
    nameAscii TEXT,
    geonameid INT
);
DROP TABLE IF EXISTS featureCodes;
CREATE TABLE featureCodes (
    code        CHAR(7),
    name        VARCHAR(200),
    description TEXT
);
DROP TABLE IF EXISTS timeZones;
CREATE TABLE timeZones (
    timeZoneId VARCHAR(200),
    GMT_offset NUMERIC(3,1),
    DST_offset NUMERIC(3,1),
    raw_offset NUMERIC(3,1)
);
DROP TABLE IF EXISTS continentCodes;
CREATE TABLE continentCodes (
    code      CHAR(2),
    name      VARCHAR(20),
    geonameid INT
);
DROP TABLE IF EXISTS postalcodes;
CREATE TABLE postalcodes (
    countrycode CHAR(2),
    postalcode  VARCHAR(20),
    placename   VARCHAR(180),
    admin1name  VARCHAR(100),
    admin1code  VARCHAR(20),
    admin2name  VARCHAR(100),
    admin2code  VARCHAR(20),
    admin3name  VARCHAR(100),
    admin3code  VARCHAR(20),
    latitude    FLOAT,
    longitude   FLOAT,
    accuracy    SMALLINT
);
ALTER TABLE ONLY alternatename
    ADD CONSTRAINT pk_alternatenameid PRIMARY KEY (alternatenameid);
ALTER TABLE ONLY geoname
    ADD CONSTRAINT pk_geonameid PRIMARY KEY (geonameid);
ALTER TABLE ONLY countryinfo
    ADD CONSTRAINT pk_iso_alpha2 PRIMARY KEY (iso_alpha2);
ALTER TABLE ONLY countryinfo
    ADD CONSTRAINT fk_geonameid FOREIGN KEY (geonameid) REFERENCES geoname(geonameid);
ALTER TABLE ONLY alternatename
    ADD CONSTRAINT fk_geonameid FOREIGN KEY (geonameid) REFERENCES geoname(geonameid);
EOT

: <<'COMMENT_BLOCK_1'
# check if needed directories do already exsist
if [ -d "$WORKPATH" ]; then
    echo "$WORKPATH exists..."
    sleep 0
else
    echo "$WORKPATH and subdirectories will be created..."
    mkdir -p $WORKPATH/{$TMPPATH,$PCPATH}
    echo "created $WORKPATH"
fi
COMMENT_BLOCK_1

echo
echo ",---- STARTING (downloading, unpacking and preparing)"
cd $WORKPATH

if [[ $download == "f" ]]; then
	echo "Skipping download, using existing files"
else
	for i in $FILES
	do
		wget -N -q "http://download.geonames.org/export/dump/$i" # get newer files
		if [ $i -nt $PREFIX$i ] || [ ! -e $PREFIX$i ] ; then
			cp -p $i $PREFIX$i
			unzip -u -q $i

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
			echo "| $1 has been downloaded";
		else
			echo "| $i is already the latest version"
		fi
	done

	# download the postalcodes. You must know yourself the url
	cd $WORKPATH
	wget -q -N "http://download.geonames.org/export/zip/allCountries.zip"

	if [ $WORKPATH/allCountries.zip -nt $WORKPATH/allCountries$PREFIX.zip ] || [ ! -e $WORKPATH/allCountries.zip ]; then
		echo "Attempt to unzip $WORKPATH/allCountries.zip file..."
		unzip -u -q $WORKPATH/allCountries.zip
		cp -p $WORKPATH/allCountries.zip $WORKPATH/allCountries$PREFIX.zip
		echo "| ....zip has been downloaded"
	else
		echo "| ....zip is already the latest version"
	fi
fi

echo "+---- FILL DATABASE ( this takes 2 days on my machine )"

psql geonames <<EOT
copy geoname (geonameid,name,asciiname,alternatenames,latitude,longitude,fclass,fcode,country,cc2,admin1,admin2,admin3,admin4,population,elevation,gtopo30,timezone,moddate) from '${WORKPATH}/allCountries.txt' null as '';
copy postalcodes (countrycode,postalcode,placename,admin1name,admin1code,admin2name,admin2code,admin3name,admin3code,latitude,longitude,accuracy) from '${WORKPATH}/allCountries.txt' null as '';
copy timeZones (timeZoneId,GMT_offset,DST_offset,raw_offset) from '${WORKPATH}/timeZones.txt.tmp' null as '';
copy featureCodes (code,name,description) from '${WORKPATH}/featureCodes_en.txt' null as '';
copy admin1CodesAscii (code,name,nameAscii,geonameid) from '${WORKPATH}/admin1CodesASCII.txt' null as '';
copy admin2CodesAscii (code,name,nameAscii,geonameid) from '${WORKPATH}/admin2Codes.txt' null as '';
copy iso_languagecodes (iso_639_3,iso_639_2,iso_639_1,language_name) from '${WORKPATH}/iso-languagecodes.txt.tmp' null as '';
copy countryInfo (iso_alpha2,iso_alpha3,iso_numeric,fips_code,country,capital,areainsqkm,population,continent,tld,currency_code,currency_name,phone,postal,postalRegex,languages,geonameid,neighbours,equivalent_fips_code) from '${WORKPATH}/countryInfo.txt.tmp' null as '';
copy alternatename (alternatenameid,geonameid,isoLanguage,alternateName,isPreferredName,isShortName) from '${WORKPATH}/alternateNames.txt' null as '';
INSERT INTO continentCodes VALUES ('AF', 'Africa', 6255146);
INSERT INTO continentCodes VALUES ('AS', 'Asia', 6255147);
INSERT INTO continentCodes VALUES ('EU', 'Europe', 6255148);
INSERT INTO continentCodes VALUES ('NA', 'North America', 6255149);
INSERT INTO continentCodes VALUES ('OC', 'Oceania', 6255150);
INSERT INTO continentCodes VALUES ('SA', 'South America', 6255151);
INSERT INTO continentCodes VALUES ('AN', 'Antarctica', 6255152);
CREATE INDEX index_countryinfo_geonameid ON countryinfo USING hash (geonameid);
CREATE INDEX index_alternatename_geonameid ON alternatename USING hash (geonameid);
EOT
echo "'----- DONE ( have fun... )"