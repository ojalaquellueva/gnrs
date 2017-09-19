<?php

echo "Updating based on herbaria, cities, keyword, taxa...";
$msg_error="Failed!\r\n";
$sql="
	update bien2.viewFullOccurrence v join geoscrub_taxa gt join geoscrub g
	on v.OccurID=gt.occurID and gt.geoscrubID=g.geoscrubID
	set 
	v.isCultivated=g.isCultivated,
	v.isCultivatedReason=g.isCultivatedReason
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

echo "Reseting columns for FIA plots...";
$msg_error="Failed to set isCultivated=0 for all FIA plots!\r\n";
$sql="
	update bien2.viewFullOccurrence v
	set 
	v.isCultivated=1,
	v.isCultivatedReason='FIA disturbed'
	where v.SurveyType='Plot' and v.DataSource='FIA' and (v.isCultivated is null or v.isCultivated=0);
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

echo "Updating flags for FIA plots...";
$msg_error="Failed!\r\n";
$sql="
	update bien2.viewFullOccurrence v join bien2.PlotMetaDataDimension p join FIA_COND f
	on v.DBPlotID=p.DBPlotID and p.PlotCD=f.PLT_CN
	set 
	v.isCultivated=0,
	v.isCultivatedReason=NULL
	where v.SurveyType='Plot' and
	v.DataSource='FIA' and 
	p.DBSourceName='FIA' and 
	f.oldgrowth=1 and
       	v.isCultivatedReason='FIA disturbed'
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

echo "Updating flags based on original `cultivated` field...";
$msg_error="Failed!\r\n";
$sql="
	update bien2.viewFullOccurrence v join bien2.IndividualObservation i
	on v.ObservationID=i.ObservationID
	set 
	v.isCultivated=1,
	isCultivatedReason=trim(
		CONCAT_WS(
			' ',
			replace(if(isCultivatedReason is null,'',trim(isCultivatedReason)),'As per original record',''), 
			'As per original record'
		)
	)
	where i.cultivated=1;

";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

?>
