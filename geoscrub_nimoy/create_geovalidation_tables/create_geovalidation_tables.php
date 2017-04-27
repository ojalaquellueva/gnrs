<?php
// Populates geovalidation tables in bien2 db
// these table linked 1:1 with PlotMetaDataDimension and IndividualObservation
//
// Brad Boyle (bboyle@email.arizona.edu)
// 9 November 2010

include "params.inc";	// everything you need to set is here and dbconfig.inc

if (confirm($confmsg)) {
	// connect to database
	if (!($dbh=db_connect($HOST,$USER,$PWD,$DB_MAIN,$echo_on))) die();
}

// create empty mysql tables
include_once "create_tables.inc";

// Populate IDs for geoIndividualObservation
echo "Populating IDs in table $geotbl1...";
$msg_error = "Failed to insert IDs into table $geotbl1!";
$sql = "INSERT INTO $geotbl1 (
	ID
	) 
	SELECT
	ObservationID
	FROM
	IndividualObservation
	;
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));


// Populate IDs for geoIndividualObservation
echo "Populating IDs in table $geotbl2...";
$msg_error = "Failed to insert IDs into table $geotbl2!";
$sql = "INSERT INTO $geotbl2 (
	ID
	) 
	SELECT
	DBPlotID
	FROM
	PlotMetaDataDimension
	;
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

mysql_close($dbh);

echo "\r\nOperation completed\r\n\r\n";

?>
