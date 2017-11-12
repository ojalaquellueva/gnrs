<?php

include $CONFIG_DIR.'db_config.php';
$dbh = pg_connect("host=$HOST dbname=$DB user=$USER");
if(!$dbh) die("Error : Unable to open database\r\n");

?>