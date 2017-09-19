<?php

echo "Selecting records near herbaria...";

// Create temporary table
$msg_error="Failed to drop previous table `cult_herbaria`!\r\n";
$sql="drop table if exists cult_herbaria;";
if (sql_execute($sql,TRUE,$echo_on,"",$msg_error));
$msg_error="Failed to create temporary table `cult_herbaria`!\r\n";
$sql="
	create table cult_herbaria (
		geoscrubID integer(11) unsigned not null,
		minDistToHerbarium decimal(11,1) default null,
		primary key (geoscrubID)
	) ENGINE=MyISAM;
";
if (sql_execute($sql,TRUE,$echo_on,"",$msg_error));

// insert reocrds
$msg_error="Failed insert into `cult_herbaria`!\r\n";
$sql="
	insert into cult_herbaria(
		geoscrubID,
		minDistToHerbarium
	)
	select geoscrubID, min(geodistkm(obsLat,obsLong,herbLat,herbLong)) as minDistToHerbarium
	from (
		select geoscrubID, countryID, latitudeDecimalVerbatim as obsLat, longitudeDecimalVerbatim as obsLong 
		from geoscrub
		where isBadLatLong=0 and countryID is not null
	) as o,
	(
		select minDistKm, countryID, latitude as herbLat, longitude as herbLong 
		from herbaria
		where countryID is not null
	) as h
	where o.countryID=h.countryID
	group by geoscrubID
	having minDistToHerbarium<$minDistKm
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

echo "Updating records in geoscrub...";
// insert records
$msg_error="Failed!\r\n";
$sql="
	update geoscrub g join cult_herbaria h
	on g.geoscrubID=h.geoscrubID 
	set
	g.isCultivated=1,
	g.isCultivatedReason=trim(
		CONCAT_WS(
			' ',
			replace(if(g.isCultivatedReason is null,'',trim(g.isCultivatedReason)),'Proximity to herbarium',''),
			'Proximity to herbarium'
		)
	)
	;	
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// Delete temporary table if requested
// Set $clean_up in params.inc
// You may want to keep this table if you need to examine
// properties of observations as a function of distance
// to nearest herbarium
if ($clean_up===true) {
	$msg_error="Failed to drop temporary table `cult_herbaria`!\r\n";
	$sql="drop table if exists cult_herbaria;";
	if (sql_execute($sql,TRUE,$echo_on,"",$msg_error));
}

?>
