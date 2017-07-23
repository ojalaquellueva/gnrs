<?php

echo "Flagging records by locality keywords...";

$msg_error="Failed!\r\n";
$sql="
	update geoscrub
	set
	isCultivated=1,
	isCultivatedReason=trim(
		CONCAT_WS(
			' ',
			replace(if(isCultivatedReason is null,'',trim(isCultivatedReason)),'Keywords in locality',''), 
			'Keywords in locality'
		)
	)
	where
	localityVerbatim like '%cultivated%' or
	localityVerbatim like '%cultivad%' or
	localityVerbatim like '%ornamental%' or
	localityVerbatim like '%garden%' or
	localityVerbatim like '%jardin%' or
	localityVerbatim like '%jardín%' or
	localityVerbatim like '%jardim%' or
	localityVerbatim like '%plantation%' or
	localityVerbatim like '%plantacion%' or
	localityVerbatim like '%plantación%' or
	localityVerbatim like '%universit%' or
	localityVerbatim like '%universidad%' or
	localityVerbatim like '%campus%' or 
	localityVerbatim like '%urban%' or
	localityVerbatim like '%greenhouse%' or
	localityVerbatim like '%arboretum%' or
	localityVerbatim like '%farm%' or
	localityVerbatim like '%weed%' or
	localityVerbatim like '%corn field%'
	;
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));


?>
