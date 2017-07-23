<?php
// Updates geovalidation tables in bien2 db
// Based on geovalidation result tables in db geoscrub
//
// Brad Boyle (bboyle@email.arizona.edu)
// 7 Feb. 2011

include "params.inc";	// everything you need to set is here and dbconfig.inc

if (confirm($confmsg)) {
	// connect to database
	if (!($dbh=db_connect($HOST,$USER,$PWD,$DB_MAIN,$echo_on))) die();
}

$srcTbls = array(
	$tbl_ind,
	$tbl_plot
);

foreach ($srcTbls as $srcTbl) {
	$geoTbl="geo".$srcTbl;
	echo "Updating table '$geoTbl':\r\n";

	echo "  Geovalidation results...";
	$msg_error = "Failed!";
	$sql="
		UPDATE $DB_MAIN.$geoTbl g INNER JOIN (
			SELECT
			sourceID,
			isInCountry,
			distErrCountry,
			isInStateProvince,
			distErrStateProvince,
			isInCountyParish,
			distErrCountyParish
			FROM $DB_GEO.geoscrub
			WHERE sourceTable='$srcTbl'
		) AS g2
		ON g.ID=g2.sourceID
		SET 
		g.isInCountry=g2.isInCountry,
		g.countryDistError=g2.distErrCountry,
		g.isInStateProvince=g2.isInStateProvince,
		g.stateProvinceDistError=g2.distErrStateProvince,
		g.isInCountyParish=g2.isInCountyParish,
		g.countyParishDistError=g2.distErrCountyParish;
	";
	if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

	echo "  Country names...";
	$msg_error = "Failed!";
	$sql="
		UPDATE $DB_MAIN.$geoTbl g INNER JOIN (
			SELECT g2.sourceID, c.isoCode, c.countryNameStd
			FROM $DB_GEO.geoscrub AS g2 INNER JOIN $DB_GEO.country AS c
			ON g2.countryID=c.countryID
			WHERE g2.sourceTable='$srcTbl'
		) AS c
		ON g.ID=c.sourceID
		SET 
		g.countryISO=c.isoCode,
		g.countryStd=c.countryNameStd;
	";
	if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

	echo "  State/Province names...";
	$msg_error = "Failed!";
	$sql="
		UPDATE $DB_MAIN.$geoTbl g INNER JOIN (
			SELECT g2.sourceID, s.stateProvinceNameStd
			FROM $DB_GEO.geoscrub AS g2 INNER JOIN $DB_GEO.stateProvince AS s
			ON g2.stateProvinceID=s.stateProvinceID
			WHERE g2.sourceTable='$srcTbl'
		) AS s
		ON g.ID=s.sourceID
		SET 
		g.stateProvinceStd=s.stateProvinceNameStd;
	";
	if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

	echo "  County/Parish names...";
	$msg_error = "Failed!";
	$sql="
		UPDATE $DB_MAIN.$geoTbl g INNER JOIN (
			SELECT g2.sourceID, c.countyParishNameStd
			FROM $DB_GEO.geoscrub AS g2 INNER JOIN $DB_GEO.countyParish AS c
			ON g2.countyParishID=c.countyParishID
			WHERE g2.sourceTable='$srcTbl'
		) AS c
		ON g.ID=c.sourceID
		SET 
		g.countyParishStd=c.countyParishNameStd;
	";
	if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));
}

mysql_close($dbh);

echo "\r\nOperation completed\r\n\r\n";

?>
