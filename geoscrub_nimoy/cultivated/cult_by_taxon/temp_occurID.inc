<?php
// temporary script to populate occurID in table geoscrub taxa
// this step is now included in flag_by_taxa.inc

// populate table using plot observations
echo "Updating occurID by plots...";
$msg_error="\r\nFailed to update plot observations in table `geoscrub_taxa`!\r\n";
$sql="
	update geoscrub_taxa gt join geoscrub g join bien2.viewFullOccurrence v
	on gt.geoscrubID=g.geoscrubID and g.sourceID=v.DBPlotID		
	set
		gt.occurID=v.OccurID
	where v.SurveyType='Plot' and g.sourceTable='PlotMetaDataDimension'; 
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// populate table using specimen observations
echo "Updating occurID by specimens...";
$msg_error="\r\nFailed to update specimen observations in table `geoscrub_taxa`!\r\n";	
$sql="
	update geoscrub_taxa gt join geoscrub g join bien2.viewFullOccurrence v
	on gt.geoscrubID=g.geoscrubID and g.sourceID=v.ObservationID
	set
		gt.occurID=v.OccurID
	where v.SurveyType='Specimen' and g.sourceTable='IndividualObservation'; 
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));


?>
