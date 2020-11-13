#! /usr/bin/perl
# consolidator.pl: Consolidates batches from the Geographic Name Resolution 
# 	Service (GNRS)
# Called by: gnrspar.pl
# Author: Naim Matasci <nmatasci@iplantcollaborative.org>
###############################################################################

use strict;

process(@ARGV);

sub process {
	my $tmpfolder = shift;
	my $dout = shift;  # Output file delimiter option
	my $mapfile   = "$tmpfolder/map.tab";
	my $pidfile   = "$tmpfolder/pids.tab";
	my %map;
	my %pids;
	
	# Input file delimiter, as output by gnrspar.pl
	# Use tab (TSV) to properly handle embedded commas
	my $din = '\t';

	#Set the output file delimiter
	if ($dout eq 't') {
		$dout = "\t";
	} elsif ($dout eq 'c') {
		$dout = ',';
	} else {
		die("Not a valid delimiter, must be c or t");
	}

	#Load the mapping of names to internal ids
	open my $MAP, "<$mapfile" or die "Cannot open the map file $mapfile: $!\n";
	while (<$MAP>) {
		chomp;
		my ( $id, $name ) = split /\t/, $_;
		$map{$id} = $name;
	}
	close $MAP;

	#Load the mapping of the original ids, if it exist
	if ( -e $pidfile ) {
		open my $PID, "<$pidfile"
		  or die "Cannot open the PID file $pidfile: $!\n";
		while (<$PID>) {
			chomp;
			my ( $name, $pid ) = split /\t/, $_;
			$pids{$name} = $pid;
		}
		close $PID;

	}

	#Load the list of files to consolidate
	opendir my $IND, $tmpfolder or die "Cannot find $tmpfolder: $!\n";
	my @files = grep { /out_\d+\.txt/ } readdir($IND); #the structure of the file is out_0.txt, out_1.txt. etc
	closedir $IND;
	
	#Header tracker
	my $header = 0;

	#process the files in the correct order
	for ( my $i = 0 ; $i < @files ; $i++ ) {
		my @consolidated;
		
		#Load the list of names
		open my $NL, "<$tmpfolder/out_$i.txt"
		  or die "Cannot open processed names file $tmpfolder/out_$i.txt: $!\n";
		my @names_list = <$NL>;
		close $NL;
		
		# If a header hasn't been written, create the file and write the header 
		if ( !$header ) {
			$header = shift(@names_list);
			open my $OF, ">$tmpfolder/output.csv"
			  or die "Cannot create output file $tmpfolder/output.csv: $!\n";
			print $OF "$header";
			close $OF;
		} else {
			# The first line of every remaining file is the header, so it 
			# always needs to be removed
			shift @names_list; 
		}
		
		# Go over the list of names
		for (@names_list) {
			chomp;
			
			# Split the input line
			my @fields = split /$din/, $_; # split on delimiter
			
=pod	
# Cutting this next section to avoid "shifting" the first column
# of output into oblivion. pid-mapping isn't working anyway
		
			my $id     = "$i." . shift(@fields); #recreates the internal id
			
			my $ref    = $map{$id}; # Use the internal id to retrieve the original name

			if (%pids) {
				#$ref = $pids{ $map{$id} } . "|$map{$id}"; #and the primary id, if present
				$ref = $pids{ $map{$id} }; 	#Just the integer ID
			}
=cut
			# Form the output line
			#push @consolidated, join "$dout", ( "$ref", @fields );
			push @consolidated, join "$dout", ( @fields );
		}
		
		#Append the batch of processed names to the output file. 
		open my $OF, ">>$tmpfolder/output.csv"
		  or die
		  "Cannot write output file $tmpfolder/output.csv: $!\n";
		print $OF join( "\n", @consolidated ), "\n";
		close $OF;
	}
}

