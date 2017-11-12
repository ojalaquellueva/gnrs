<?php
// Scrubs and indexes country names in countryScrubbed
// 1. Converts any 2- and 3-letter iso codes to canonical country name
// 2. Converts any utf8, iso or ascii codes to text
// 3. Converts all names to plain ascii representation (accents to plain ascii)
// 4. Attempts to match plain ascii to canonical name and iso code via 
//    countryName table

// clear previous values, just in case
$msg_error="Failed to set countryScrubbed result fields to NULL!\r\n";
$sql="UPDATE countryScrubbed 
	SET 
	countryScrubbed=NULL,
	countryScrubbedPlainAscii=NULL,
	countryID=NULL	
	;";
if (sql_execute($sql,TRUE,$echo_on,"",$msg_error));

// Convert any countries represented by 2-letter ISO codes
echo "Converting 2-letter ISO codes...";
$msg_error="Failed to convert 2-letter ISO codes!\r\n";
$sql="
	UPDATE countryScrubbed s INNER JOIN country c
	ON s.countryVerbatim=c.isoCode
	SET 
	s.countryScrubbed=c.countryNameStd,
	s.countryScrubbedPlainAscii=c.countryNameStd,
	s.countryID=c.countryID;
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// Convert countries represented by 3-letter codes
echo "Converting 3-letter codes...";
$msg_error="Failed to convert 3-letter codes!\r\n";
$sql="
	UPDATE countryScrubbed s INNER JOIN country c
	ON s.countryVerbatim=c.countryCode3Char
	SET 
	s.countryScrubbed=c.countryNameStd,
	s.countryScrubbedPlainAscii=c.countryNameStd,
	s.countryID=c.countryID
	WHERE s.countryID IS NULL;
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

///////// Convert utf8 & ascii codes to text ///////

echo "Converting utf8 & ascii codes to text...";
$msg_error="Failed to convert utf8 & ascii codes to text!\r\n";

// Loop through table
// Select only records not yet scrubbed
$query="
	SELECT countryVerbatim 
	FROM countryScrubbed
	WHERE countryScrubbed IS NULL;
";
$result=mysql_query($query);
$num_rows=mysql_numrows($result);

if ($num_rows>0) {
	while ($row=mysql_fetch_array($result, MYSQL_ASSOC)) {
		$countryVerbatim=$row{'countryVerbatim'};
		$str=trim($countryVerbatim);

		// strip unnecessary punctuation
		$str=str_replace(chr(63),"",$str);  //  ?
		$str=str_replace(chr(34),"",$str);  //  "
		$str=str_replace(chr(39),"",$str);  //  '

		// Populate CountryScrubbed (verbatim name with codes converted to text)
		$trans = new Latin1UTF8(); //convert utf8 codes
		$country_utf8Conv=$trans->mixed_to_latin1($str); // convert iso/ascii codes
		$countryScrubbed=iso2text($country_utf8Conv);  
		$sql="UPDATE `countryScrubbed`
			SET countryScrubbed='$countryScrubbed'
			WHERE countryVerbatim=\"$countryVerbatim\" AND countryScrubbed IS NULL;
			";
		$msg_error="Failed to update countryScrubbed for countryVerbatim=$countryVerbatim!";
		if (sql_execute($sql,TRUE,$echo_on,'',$msg_error));

		// Populate CountryPlainAscii
		$countryScrubbedPlainAscii=ext2ascii($countryScrubbed);
		$sql="UPDATE `countryScrubbed`
			SET countryScrubbedPlainAscii='$countryScrubbedPlainAscii'
			WHERE countryVerbatim=\"$countryVerbatim\" AND countryScrubbedPlainAscii IS NULL;
			";
		$msg_error="Failed to update countryScrubbed for countryVerbatim=$countryVerbatim!";
			if (sql_execute($sql,TRUE,$echo_on,'',$msg_error));
	}
}

echo $msg_success;

// Find missing ISO codes using plain ascii names
echo "Indexing countries using plain ascii names...";
$msg_error="Failed to index countries using plain ascii names!\r\n";
$sql="
	UPDATE countryScrubbed s INNER JOIN countryName n
	ON s.countryScrubbedPlainAscii=n.countryName
	SET 
	s.countryID=n.countryID
	WHERE s.countryID IS NULL;
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// Find missing ISO codes using scrubbed names
echo "Indexing countries using scrubbed names...";
$msg_error="Failed to index countries using scrubbed names!\r\n";
$sql="
	UPDATE countryScrubbed s INNER JOIN (
		SELECT DISTINCT countryID, countryName
		FROM countryName
		) AS n
	ON s.countryScrubbed=n.countryName
	SET s.countryID=n.countryID
	WHERE s.countryID IS NULL;
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

?>
