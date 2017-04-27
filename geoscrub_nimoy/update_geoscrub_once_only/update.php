<?php
// Creates empty table `geoscrub` in geoscrub database
// and populates with original record IDs and verbatim 
// locality values from main database

include "params.inc"; // everything you need to set is here

if (confirm($confmsg)) echo "\r\nBegin operation\r\n";

// connect to database
if (!($dbh=db_connect($HOST,$USER,$PWD,$DB_GEO,$echo_on))) die();

include $timer_on; // start timer

echo "Setting geoscrub columns to NULL...";
$msg_error = "failed!\r\n";
$sql="
	UPDATE $geotbl
	SET 
	isInCountry=NULL,
	distErrCountry=NULL,
	isInStateProvince=NULL,
	distErrCountry=NULL;
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

echo "Updating country results from `geoIndividualObservation`...";
$msg_error = "update failed!\r\n";
$sql="
	UPDATE $geotbl g INNER JOIN geoIndividualObservation g2
	ON g.sourceID=g2.ObservationID
	SET 
	g.isInCountry=g2.inCountry,
	g.distErrCountry=g2.distError
	WHERE g.sourceTable='IndividualObservation';
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

echo "Updating country results from `geoPlotMetaDataDimension`...";
$msg_error = "update failed!\r\n";
$sql="
	UPDATE $geotbl g INNER JOIN geoPlotMetaDataDimension g2
	ON g.sourceID=g2.DBPlotID
	SET 
	g.isInCountry=g2.inCountry,
	g.distErrCountry=g2.distError
	WHERE g.sourceTable='PlotMetaDataDimension';
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

echo "Updating state results from `geoIndividualObservationStateLevel`...";
$msg_error = "update failed!\r\n";
$sql="
	UPDATE $geotbl g INNER JOIN geoIndividualObservationStateLevel g2
	ON g.sourceID=g2.ObservationID
	SET 
	g.isInStateProvince=g2.inState,
	g.distErrStateProvince=g2.stateError
	WHERE g.sourceTable='IndividualObservation';
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

echo "Updating state results from `geoPlotMetaDataDimensionStateLevel`...";
$msg_error = "update failed!\r\n";
$sql="
	UPDATE $geotbl g INNER JOIN geoPlotMetaDataDimensionStateLevel g2
	ON g.sourceID=g2.DBPlotID
	SET 
	g.isInStateProvince=g2.inState,
	g.distErrStateProvince=g2.stateError
	WHERE g.sourceTable='PlotMetaDataDimension';
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

// Close connection and report time elapsed
mysql_close($dbh);
include $timer_off_echo;
echo "Operation completed\r\n\r\n";

?>
