<?php
// Scrubs and indexes country names in countryScrubbed
// 1. Converts any 2- and 3-letter iso codes to canonical country name
// 2. Converts any utf8, iso or ascii codes to text
// 3. Converts all names to plain ascii representation (accents to plain ascii)
// 4. Attempts to match plain ascii to canonical name and iso code via 
//    countryName table

// clear previous values, just in case
$msg_error="Failed to set $tblPoldivScrubbed result fields to NULL!\r\n";
$sql="UPDATE $tblPoldivScrubbed 
	SET 
	$poldivScrubbed=NULL,
	$poldivPlainAscii=NULL,
	$poldivID=NULL	
	;";
if (sql_execute($sql,TRUE,$echo_on,"",$msg_error));

// Convert any poldivs represented by unique codes
// Also assumes that the standard name is plain ascii
// Make sure this is true!
echo "Converting $poldiv codes in name field...";
$msg_error="Failed to convert based on codes in `$uniqueCodeFld` field!\r\n";
$sql="
	UPDATE $tblPoldivScrubbed s INNER JOIN $tblPoldivStd p
	ON s.$poldivVerbatim=p.$uniqueCodeFld
	SET 
	s.$poldivScrubbed=p.$poldivStd,
	s.$poldivPlainAscii=p.$poldivStd,
	s.$poldivID=p.$poldivID,
	s.message='Converted from unique code $uniqueCodeFld';
";
if (sql_execute($sql,TRUE,$echo_on,"",$msg_error));

// Convert any poldivs represented by dependent codes
// Dependent codes require parent poldiv as well (e.g., USA+AZ)
// Also assumes that the standard name is plain ascii
// Make sure this is true!
$msg_error="Failed to convert based on codes in field `$dependentCodeFld`!\r\n";
$sql="
	UPDATE $tblPoldivScrubbed s INNER JOIN $tblPoldivStd p
	ON s.$poldivVerbatim=p.$dependentCodeFld
	AND s.$poldivParentID=p.$poldivParentID
	SET 
	s.$poldivScrubbed=p.$poldivStd,
	s.$poldivPlainAscii=p.$poldivStd,
	s.$poldivID=p.$poldivID,
	s.message='Converted from dependent code $dependentCodeFld';
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// Remove single quotes temporarily
echo "Removing single quotes...";
$msg_error="Failed!\r\n";
$sql="
	UPDATE $tblPoldivScrubbed 
	SET 
	$poldivVerbatim=REPLACE($poldivVerbatim,\"'\",\"@@@\")
	;
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));


///////// Convert utf8 & ascii codes to text ///////

echo "Converting utf8 & ascii codes to text...";
$msg_error="Failed to convert utf8 & ascii codes to text!\r\n";

// Loop through table
// Select only records not yet scrubbed
$query="
	SELECT DISTINCT $poldivVerbatim, $poldivParentID
	FROM $tblPoldivScrubbed
	WHERE $poldivVerbatim IS NOT NULL 
	AND $poldivParentID IS NOT NULL 
	AND $poldivScrubbed IS NULL;
";
$result=mysql_query($query);
$num_rows=mysql_numrows($result);

if ($num_rows>0) {
	while ($row=mysql_fetch_array($result, MYSQL_ASSOC)) {
		$pd_verbatim=$row{$poldivVerbatim};
		$str=trim($pd_verbatim);
		$pd_parent_id=$row{$poldivParentID};

		// strip unnecessary punctuation
		$str=str_replace(chr(63),"",$str);  //  ?
		$str=str_replace(chr(34),"",$str);  //  "
	//	$str=str_replace(chr(39),"@@@",$str);  //  ', symbol enables these to be reset after

		// Populate scrubbed table (verbatim name with codes converted to text)
		$trans = new Latin1UTF8(); //convert utf8 codes
		$pd_utf8Conv=$trans->mixed_to_latin1($str); // convert iso/ascii codes
		$pd_scrubbed=iso2text($pd_utf8Conv);  
		$sql="UPDATE `$tblPoldivScrubbed`
			SET $poldivScrubbed='$pd_scrubbed' 
			WHERE $poldivVerbatim='$pd_verbatim'
			AND $poldivParentID=$pd_parent_id 
		       	AND $poldivScrubbed IS NULL;
			";
		$msg_error="Failed to update $poldivScrubbed for $poldivVerbatim=$pd_verbatim!";
		if (sql_execute($sql,TRUE,$echo_on,'',$msg_error));

		// Populate CountryPlainAscii
		$pd_scrubbedPlainAscii=ext2ascii($pd_scrubbed);
		$sql="UPDATE `$tblPoldivScrubbed`
			SET $poldivPlainAscii='$pd_scrubbedPlainAscii' 
			WHERE $poldivVerbatim='$pd_verbatim' 
			AND $poldivParentID=$pd_parent_id 
			AND $poldivPlainAscii IS NULL;
			";
		$msg_error="Failed to update $poldivScrubbed for $poldivVerbatim=$pd_verbatim!";
			if (sql_execute($sql,TRUE,$echo_on,'',$msg_error));
	}
}

echo $msg_success;

// Put back any single quotes
echo "Fixing single quotes...";
$msg_error="Failed!\r\n";
$sql="
	UPDATE $tblPoldivScrubbed 
	SET 
	$poldivVerbatim=REPLACE($poldivVerbatim,\"@@@\",\"'\"),
	$poldivScrubbed=REPLACE($poldivScrubbed,\"@@@\",\"'\"),
	$poldivPlainAscii=REPLACE($poldivPlainAscii,\"@@@\",\"'\")
	;
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// The following gets nested inside other queries
// Retrieves all poldiv names (including synonyms) plus ID of standard name
// and ID of parent poldiv
$sql_std="
		SELECT DISTINCT
		p.$poldivParentID, p.$poldivID, s.$poldivSynName
		FROM $poldivParent pt INNER JOIN $tblPoldivStd p INNER JOIN $tblPoldivSyn s
		ON pt.$poldivParentID=p.$poldivParentID AND p.$poldivID=s.$poldivID
";

// Find missing poldivs using plain ascii names
echo "Indexing $poldiv using plain ascii names...";
$msg_error="Failed!\r\n";
$sql="
	UPDATE $tblPoldivScrubbed s INNER JOIN ($sql_std) AS n
	ON s.$poldivPlainAscii=n.$poldivSynName
	AND s.$poldivParentID=n.$poldivParentID
	SET 
	s.$poldivID=n.$poldivID,
	s.message='Converted from plain ascii'
	WHERE s.$poldivID IS NULL AND s.$poldivParentID IS NOT NULL;
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

// Find missing poldivs using scrubbed names
echo "Indexing $poldiv using scrubbed names...";
$msg_error="Failed!\r\n";
$sql="
	UPDATE $tblPoldivScrubbed s INNER JOIN ($sql_std) AS n
	ON s.$poldivScrubbed=n.$poldivSynName
	AND s.$poldivParentID=n.$poldivParentID
	SET 
	s.$poldivID=n.$poldivID,
	s.message='Converted from scrubbed name'
	WHERE s.$poldivID IS NULL AND s.$poldivParentID IS NOT NULL;
";
if (sql_execute($sql,TRUE,$echo_on,$msg_success,$msg_error));

?>
