<?php

$dbh = pg_connect("host=$HOST dbname=$DB user=$user");
if(!$dbh) die("Error : Unable to open database\r\n");

?>