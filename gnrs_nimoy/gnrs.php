<?php

///////////////////////////////////////////////
// Evaluates validity of country-state-county
// triplet against GNRS reference tables
///////////////////////////////////////////////

// Load params if not already called
include "params.php";

// Open write connection $dbh
$user=$USER_W;
include "db_connect.php";		

include $includes_dir."load_test_data.php";
include $includes_dir."check_country.php";
include $includes_dir."check_state_province.php";
include $includes_dir."check_county_parish.php";

// Close the connection
pg_close($dbh);

?>