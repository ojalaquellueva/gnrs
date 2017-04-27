<?php
// Inserts verbatim (unvalidated) data from main database into table `geoscrub`
// NOTE: for the moment, am not inserting locality 
// will do so when we move onto 

echo "Inserting records from `$DB_MAIN`.`IndividualObservation`...";
$msg_error = "Failed to insert records from `$DB_MAIN`.`IndividualObservation`!\r\n";
$sql="
	INSERT INTO $DB_GEO.geoscrub (
		sourceTable,
		sourceID,
		countryVerbatim,
		stateProvinceVerbatim,
		countyParishVerbatim,
		elevationVerbatim,
		elevMaxVerbatim,
		elevMinVerbatim,
		latitudeDecimalVerbatim,
		longitudeDecimalVerbatim,
		localityVerbatim
	)
	SELECT
	'IndividualObservation',
	i.ObservationID,
	s.Country,
	s.StateProvince,
	s.County,
	NULL,
	NULL,
	NULL,
	i.DecimalLatitude,
	i.DecimalLongitude,
	s.Locality
	FROM 
	`$DB_MAIN`.`IndividualObservation` i INNER JOIN `$DB_MAIN`.`ObservationSpecimen` s
	ON i.ObservationSpecimenID=s.ObservationSpecimenID
	;
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

echo "Inserting records from `$DB_MAIN`.`PlotMetaDataDimension`...";
$msg_error = "Failed to insert records from `$DB_MAIN`.`PlotMetaDataDimension`!\r\n";
$sql="
	INSERT INTO $DB_GEO.geoscrub (
		sourceTable,
		sourceID,
		countryVerbatim,
		stateProvinceVerbatim,
		countyParishVerbatim,
		elevationVerbatim,
		elevMaxVerbatim,
		elevMinVerbatim,
		latitudeDecimalVerbatim,
		longitudeDecimalVerbatim,
		localityVerbatim
	)
	SELECT
	'PlotMetaDataDimension',
	DBPlotID,
	Country,
	StateProvince,
	County,
	NULL,
	NULL,
	NULL,
	PlotDecimalLatitude,
	PlotDecimalLongitude,
	Locality
	FROM 
	`$DB_MAIN`.`PlotMetaDataDimension`
	;
";
if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

?>
