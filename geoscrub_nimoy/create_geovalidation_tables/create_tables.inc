<?php
echo "Creating geovalidation tables...";

$script = $drop_sql;
$command = "mysql -u $USER --password=$PWD $DB_MAIN < $script";
system($command);

$script = $create_sql;
$command = "mysql -u $USER --password=$PWD $DB_MAIN < $script";
system($command);
echo "done\r\n";

?>
