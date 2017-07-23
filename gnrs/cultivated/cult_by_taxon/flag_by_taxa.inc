<?php

// Create table of geoscrub taxa if it doesn't already exist
if (exists_table('geoscrub_taxa')) {
	// if it exists, ask user if replace
	$confmsg="Replace existing table `geoscrub_taxa`?";
	$create_table = responseYesNoDie($confmsg);
} else {
	$create_table=true;	
}

if ($create_table===true) {
	echo "Creating table `geoscrub_taxa`...";
	
	// drop previous table, if any
	$msg_error="Failed to drop previous table `geoscrub_taxa`!\r\n";
	$sql="drop table if exists geoscrub_taxa;";
	if (sql_execute($sql,TRUE,$echo_on,"",$msg_error));

	// create table
	$msg_error="\r\nFailed to create table `geoscrub_taxa`!\r\n";
	$sql="
		create table geoscrub_taxa (
			geoscrubID integer(11) unsigned not null,
			occurID integer(11) unsigned default null,
			family varchar(100) default null,
			taxon varchar(255) default null,
			primary key (geoscrubID),
			index (occurID),
			index (family),
			index (taxon)
		) ENGINE=MyISAM;
	";
	if (sql_execute($sql,TRUE,$echo_on,"",$msg_error));

	// populate table using plot observations
	echo "\r                                                                          ";
	echo "\rCreating table `geoscrub_taxa`...inserting records";
	$msg_error="\r\nFailed to populate table `geoscrub_taxa` using plot observations!\r\n";
	$sql="
		insert into geoscrub_taxa (geoscrubID)
		select geoscrubID
		from geoscrub
		; 
	";
	if (sql_execute($sql,TRUE,$echo_on,"",$msg_error));

	// populate table using plot observations
	echo "\r                                                                          ";
	echo "\rCreating table `geoscrub_taxa`...updating plot observations";
	$msg_error="\r\nFailed to update plot observations in table `geoscrub_taxa`!\r\n";
	$sql="
		update geoscrub_taxa gt join geoscrub g join bien2.viewFullOccurrence v
		on gt.geoscrubID=g.geoscrubID and g.sourceID=v.DBPlotID		
		set
			gt.occurID=v.OccurID,
			gt.family=v.Family,
			gt.taxon=v.Latin
		where v.SurveyType='Plot' and g.sourceTable='PlotMetaDataDimension'; 
	";
	if (sql_execute($sql,TRUE,$echo_on,"",$msg_error));

	// populate table using specimen observations
	echo "\r                                                                          ";
	echo "\rCreating table `geoscrub_taxa`...updating specimen observations";
	$msg_error="\r\nFailed to update specimen observations in table `geoscrub_taxa`!\r\n";
	$msg_complete= "\r                                                                       \rCreating table `geoscrub_taxa`...done\r\n";	
	$sql="
		update geoscrub_taxa gt join geoscrub g join bien2.viewFullOccurrence v
		on gt.geoscrubID=g.geoscrubID and g.sourceID=v.ObservationID
		set
			gt.occurID=v.OccurID,
			gt.family=v.Family,
			gt.taxon=v.Latin
		where v.SurveyType='Specimen' and g.sourceTable='IndividualObservation'; 
	";
	if (sql_execute($sql,TRUE,$echo_on,$msg_complete,$msg_error));
}

///////////////////////////////////////////////
// Apply taxon-by-region filters
///////////////////////////////////////////////

// Pinus
$currTaxon="Pinus";
$whereTaxon = " gt.taxon LIKE 'Pinus%' ";
// list of regions where taxon is NOT found
$whereRegion = " 
	c.countryNameStd IN (
		'Costa Rica',
		'Panama',
		'Colombia',
		'Venezuela',
		'Ecuador',
		'Peru',
		'Bolivia',
		'Chile',
		'Argentina',
		'Paraguay',
		'Uruguay',
		'Brazil',
		'Guyana',
		'French Guiana',
		'Suriname'
	) 
	";
echo "Applying rules for taxon='$currTaxon'...";
$msg_error="Failed!\r\n";
$sql="
	update geoscrub_taxa gt join geoscrub g join country c
	on gt.geoscrubID=g.geoscrubID and g.countryID=c.countryID
	set
	g.isCultivated=1,
	g.isCultivatedReason=trim(
		CONCAT_WS(
			' ',
			replace(if(g.isCultivatedReason is null,'',trim(g.isCultivatedReason)),'Taxon out of natural range',''),
			'Taxon out of natural range'
		)
	)
	where $whereTaxon and $whereRegion
	;	
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// Quercus
$currTaxon="Quercus";
$whereTaxon = " gt.taxon LIKE 'Quercus%' ";
// list of regions where taxon is NOT found
$whereRegion = " 
	c.countryNameStd IN (
		'Venezuela',
		'Ecuador',
		'Peru',
		'Bolivia',
		'Chile',
		'Argentina',
		'Paraguay',
		'Uruguay',
		'Brazil',
		'Guyana',
		'French Guiana',
		'Suriname'
	) 
	";
echo "Applying rules for taxon='$currTaxon'...";
$msg_error="Failed!\r\n";
$sql="
	update geoscrub_taxa gt join geoscrub g join country c
	on gt.geoscrubID=g.geoscrubID and g.countryID=c.countryID
	set
	g.isCultivated=1,
	g.isCultivatedReason=trim(
		CONCAT_WS(
			' ',
			replace(if(g.isCultivatedReason is null,'',trim(g.isCultivatedReason)),'Taxon out of natural range',''),
			'Taxon out of natural range'
		)
	)
	where $whereTaxon and $whereRegion
	;	
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// Acer
$currTaxon="Acer";
$whereTaxon = " gt.taxon LIKE 'Acer%' ";
$whereRegion = " 
	c.countryNameStd IN (
		'Nicaragua',
		'Costa Rica',
		'Panama',
		'Colombia',
		'Venezuela',
		'Ecuador',
		'Peru',
		'Bolivia',
		'Chile',
		'Argentina',
		'Paraguay',
		'Uruguay',
		'Brazil',
		'Guyana',
		'French Guiana',
		'Suriname'
	) 
	";
echo "Applying rules for taxon='$currTaxon'...";
$msg_error="Failed!\r\n";
$sql="
	update geoscrub_taxa gt join geoscrub g join country c
	on gt.geoscrubID=g.geoscrubID and g.countryID=c.countryID
	set
	g.isCultivated=1,
	g.isCultivatedReason=trim(
		CONCAT_WS(
			' ',
			replace(if(g.isCultivatedReason is null,'',trim(g.isCultivatedReason)),'Taxon out of natural range',''),
			'Taxon out of natural range'
		)
	)
	where $whereTaxon and $whereRegion
	;	
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// Abies
$currTaxon="Abies";
$whereTaxon = " gt.taxon LIKE 'Abies%' ";
$whereRegion = " 
	c.countryNameStd IN (
		'Nicaragua',
		'Costa Rica',
		'Panama',
		'Colombia',
		'Venezuela',
		'Ecuador',
		'Peru',
		'Bolivia',
		'Chile',
		'Argentina',
		'Paraguay',
		'Uruguay',
		'Brazil',
		'Guyana',
		'French Guiana',
		'Suriname'
	) 
	";
echo "Applying rules for taxon='$currTaxon'...";
$msg_error="Failed!\r\n";
$sql="
	update geoscrub_taxa gt join geoscrub g join country c
	on gt.geoscrubID=g.geoscrubID and g.countryID=c.countryID
	set
	g.isCultivated=1,
	g.isCultivatedReason=trim(
		CONCAT_WS(
			' ',
			replace(if(g.isCultivatedReason is null,'',trim(g.isCultivatedReason)),'Taxon out of natural range',''),
			'Taxon out of natural range'
		)
	)
	where $whereTaxon and $whereRegion
	;	
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));


// Palms
$currTaxon="Palms";
$whereTaxon = " gt.family IN ('Arecaceae') ";
// list of regions where taxon is NOT found
$whereRegion = " c.countryNameStd='Canada' ";
echo "Applying rules for taxon='$currTaxon'...";
$msg_error="Failed!\r\n";
$sql="
	update geoscrub_taxa gt join geoscrub g join country c
	on gt.geoscrubID=g.geoscrubID and g.countryID=c.countryID
	set
	g.isCultivated=1,
	g.isCultivatedReason=trim(
		CONCAT_WS(
			' ',
			replace(if(g.isCultivatedReason is null,'',trim(g.isCultivatedReason)),'Taxon out of natural range',''),
			'Taxon out of natural range'
		)
	)
	where $whereTaxon and $whereRegion
	;	
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// Palms
$currTaxon="California bay";
$whereTaxon = " gt.taxon='Umbellularia californica' ";
// country<>US or country=US but state<>(CA or OR)
$whereRegion = " (g.countryID<>233 OR (g.countryID=233 AND g.stateProvinceID<>2165 AND g.stateProvinceID<>2198)) ";
echo "Applying rules for taxon='$currTaxon'...";
$msg_error="Failed!\r\n";
$sql="
	update geoscrub_taxa gt join geoscrub g
	on gt.geoscrubID=g.geoscrubID
	set
	g.isCultivated=1,
	g.isCultivatedReason=trim(
		CONCAT_WS(
			' ',
			replace(if(g.isCultivatedReason is null,'',trim(g.isCultivatedReason)),'Taxon out of natural range',''),
			'Taxon out of natural range'
		)
	)
	where $whereTaxon and $whereRegion
	;	
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

?>
