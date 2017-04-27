<?php
// Set isCultivated=1 in table geoscrub for any records within
// set radius of a city
// radius is set by a function which describes how city area 
// scales by population size
// requires table of city, countryVerbatim, countryID, lat, long, population size
// Prior to processing, field countryID must be populated by standardizing on 
// countryVerbatim field using scrub_country scripts


include "params.inc";	// everything you need to set is here and dbconfig.inc

if (confirm($confmsg)) {
	echo "\r\nBegin operation\r\n\r\n";
	include $timer_on;
}

// connect to database
if (!($dbh=db_connect($HOST,$USER,$PWD,$DB_GEO,$echo_on))) die();

include_once "flag_by_city.inc";	// insert unique names from geoscrub table

mysql_close($dbh);
include $timer_off_echo;
echo "Operation completed\r\n\r\n";

?>
