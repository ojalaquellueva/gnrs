<?php

echo "Reseting columns for FIA plots...";
$msg_error="Failed to set isCultivated=0 for all FIA plots!\r\n";
$sql="
	UPDATE geoscrub g JOIN bien2.PlotMetaDataDimension p
	ON g.sourceID=p.DBPlotID
	SET 
	g.isCultivated=1,
	g.isCultivatedReason='FIA disturbed'
	WHERE g.sourceTable='PlotMetaDataDimension'
	AND p.DBSourceName='FIA' 
	AND (g.isCultivated is NULL or g.isCultivated=0);
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

echo "Updating flags for FIA plots...";
$msg_error="Failed!\r\n";
$sql="
	UPDATE geoscrub g JOIN bien2.PlotMetaDataDimension p JOIN FIA_COND f
	ON g.sourceID==p.DBPlotID and p.PlotCD=f.PLT_CN
	SET 
	g.isCultivated=0,
	g.isCultivatedReason=NULL
	WHERE g.sourceTable='PlotMetaDataDimension'
	AND p.DBSourceName='FIA' 
	AND	f.oldgrowth=1 
	AND g.isCultivatedReason='FIA disturbed'
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

echo "Updating flags based on original `cultivated` field...";

// check this out before running. The number of "cultivated" records in 
// IndividualObservation seems too high (about half!)
$msg_error="Failed!\r\n";
$sql="
	UPDATE geoscrub g JOIN bien2.IndividualObservation i
	ON g.sourceID=i.ObservationID
	SET 
	g.isCultivated=1,
	g.isCultivatedReason=TRIM(
		CONCAT_WS(
			' ',
			REPLACE(if(isCultivatedReason IS NULL,'',TRIM(isCultivatedReason)),'As per original record',''), 
			'As per original record'
		)
	)
	WHERE g.sourceTable='IndividualObservation'
	AND i.Cultivated=1;

";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

?>
