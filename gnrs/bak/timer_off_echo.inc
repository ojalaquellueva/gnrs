<?php

//stop timer and get time
$mtime = microtime(); 
$mtime = explode(" ", $mtime); 
$mtime = $mtime[1] + $mtime[0]; 
$endtime = $mtime; 
$totaltime = ($endtime - $starttime); 
$curr_time = date("D, d M Y H:i:s",time());

// echo time elapsed
$tsecs = round($totaltime,2);
echo "\r\nTime elapsed: " . $tsecs . " seconds.\r\n";

?>
