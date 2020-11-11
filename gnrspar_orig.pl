#! /usr/bin/perl
# Previously: bin/env perl
# controller.pl: Parallel controller for the Geographic Name Resolution 
# 	Service (GNRS)
# Author: Naim Matasci <nmatasci@iplantcollaborative.org>
# Modified by: Brad Boyle <bboyle@email.arizona.edu>
#
# Usage:
# 	./cdspar.pl -in <input_filename_and_path> -out <output_filename_and_path> -nbatch <batches> -opt <makeflow_options>
# 
# Options:
# Option | Meaning | Required? | Default value | 
# -in     | Input file and path | Yes | |
# -out     | Output file and path | No | [input\_file\_name]\_cds\_results.csv | 
# -nbatch     | Number of batches | Yes |  |
# -opt     | Makeflow options | No | \
#
# Example:
#	./cdspar.pl -in "data/cds_testfile.csv" -nbatch 3
#
# Note: if get permission error, run as sudo
##############################################################################

use strict;
use POSIX;
use Getopt::Long;
use Text::CSV; 

my $APPNAME	= "gnrs";
my $binpath = $0;
$binpath =~ s/\/?\w+\.?\w*$//;
if ( !$binpath ) {
	$binpath = '.';
}
my $BINARY          = "$binpath/gnrs_batch.sh";
my $CONSOLIDATE_SCR = "$binpath/consolidator.pl";

# Master directory where all content saved
my $tmpfoldermaster = "/tmp/${APPNAME}/";

my $infile  = '';    # Input file
my $outfile = '';    # Optput file - optional [currently custom output file
					 # name not supported]
my $nbatch  = '';    # Number of batches
my $mf_opt  = '';    # makeflow options - optional
my $d = 'c';         # Default output file delimiter. For now must be 
					 # 'c' (csv), as currently this is only format supported

GetOptions(
	'in=s'      => \$infile,
	'out:s'     => \$outfile,
	'nbatch=i'  => \$nbatch,
	'opt:s'     => \$mf_opt
);

# The temporary folder needs to be in the /tmp directory 
# (see the function _clean)
# mkdir "/tmp/$APPNAME/" unless -d "/tmp/$APPNAME/"
my $tmpfolder =
  $tmpfoldermaster . time() . int( rand(10000) );    #Create a temporary folder

# If a folder with that name already exists, try another name
while ( -e $tmpfolder ) {    
	 $tmpfolder = $tmpfoldermaster . time() . int( rand(10000) );   
}

# If no output file name given
if ( !$outfile ) {
	$outfile = $infile;
	# Use the input file name w/o extension and 
	# append [APPNAME][RESULTSFILESUFFIX].csv
	$outfile =~ s/(?:\.\w+)?$/_${APPNAME}_results.csv/;    
}

# Correct windows/mac line endings, if any
my $finfo = `file $infile`;
if ( index( $finfo, 'CRLF' ) != -1) {
	# CRLF (windows)
	system "tr -d '\15\32' < $infile > ${infile}.temp";
	system "mv ${infile}.temp $infile";
} elsif ( index( $finfo, 'CR' ) != -1) {
	# CR (mac)
	system "tr '\r' '\n' < $infile > ${infile}.temp";
	system "mv ${infile}.temp $infile";
} 

# Let the magic begin
process( $infile, $nbatch, $tmpfolder, $outfile );

sub process {
	my ( $infile, $nbatch, $tmpfolder, $outfile ) = @_;

	# Get the number of records in the input file
	my $nlines = `wc -l < $infile 2>/dev/null`
	  or die("Cannot find $infile: $!\n");

	if ( $nlines == 0 ) { die("The input file $infile is empty.\n") }

	# Calculate the expected size of the batches, given their number 
	# and the number of records
	my $exp_g_size = ceil( $nlines / $nbatch );

	# Used to map the original name identifiers to the results.
	my %map;

	# Used to map the original IDs, if present
	# NOT NEEDED
	my %pids;

	# Used to store names that are already valid. Not used
# 	my @valids;

	# Indexer for the batch id
	my $batch_id = 0;

	# Indexer for the name id within a batch
	my $id = 0;

	# Line tracker
	my $tot = 0;

	# The list of lat/long pairs forming a batch
	my @batch;

	open( my $INL, "<$infile" ) or die "Cannot open input file $infile: $!\n";

	while (<$INL>) {

		$tot++;
		chomp;

		my $inputval = $_;

		# An input value that is present more than once, but with 
		# different primary id, will be processed only once
		# All the associated primary ids will be returned. 
		my $pid=$tot;    # Assign original primary id
		if ( $inputval =~ m/,/ ) {
# 			( $lat, $long ) = ( split /,/, $inputval );
# 			$inputval =~ s/^\s+//;
			if ( exists $pids{$inputval} ) {
				my @k = @{ $pids{$inputval} };
				unshift @k, $pid;
				$pids{$inputval} = \@k;
			}
			else {
				$pids{$inputval} = [$pid];
			}
		}

		if ( exists $map{$inputval} && $tot <= $nlines ) { 
			#We have already seen that name
			next;
		}
		
		# Append input value to @batch
		push @batch, $inputval;
		
		# Every input value is assigned a unique internal id, combining its
		# batch id and position within the batch
		$map{$inputval} = "$batch_id.$id";
		
		$id++;
		
		# We write a file every time we reach the predetermined batchsize 
		# or if there aren't any more input values
		if ( @batch >= $exp_g_size || $tot == $nlines ) {
			_write_out( $batch_id, \@batch, $tmpfolder );

			#			_write_screen($batch_id,\@batch);
			@batch = ();
			$batch_id++;
			$id = 0;
		}

	}
	close $INL;
	
	# Create mapping between the coordinates and the internal id
	_write_map( \%map, "$tmpfolder/map.tab" ); 

	if (%pids) {
		# Create mapping between the name and the original ids
		_write_map( \%pids, "$tmpfolder/pids.tab", 1 ); 
	}

	# Write the makeflow control file
	_generate_mfconfig( $batch_id, $tmpfolder, $outfile ); 
	
	print "tmpfolder='$tmpfolder'\n";
	my $makeflow_cmd="makeflow $mf_opt $tmpfolder/${APPNAME}.flow";
	print "makeflow_cmd='$makeflow_cmd'\n";
	
	system("makeflow $mf_opt $tmpfolder/${APPNAME}.flow"); #Run makeflow
	
	#_clean($tmpfolder); #Remove all temporary data

}

# Writes a mapping to a comma separated file
sub _write_map {
	my ( $map, $fn, $invert ) = @_;
	
	open my $MAP, ">$fn" or die "Cannot write map file $fn: $!\n";
	while ( my ( $inputval, $id ) = each %{$map} ) {
		if ($invert) { #In case the name and ids are swapped (depends which one is unique)
			my $t = $id;
			$id   = $inputval;
			$inputval = $t;
		}
		if ( ref($inputval) eq 'ARRAY' ) { 
			$inputval = join ',', @{$inputval};
		}
		print $MAP "$id,$inputval\n";
	}
	close $MAP;
}

#Writes the makeflow control file
sub _generate_mfconfig {
	my ( $batch_id, $tmpfolder, $outfile ) = @_;
	
	my $filelist; #list of output files that will be produced
	
	my $cmd = "APPBIN=$BINARY\n";
	
	# A 2-line instruction is written for every input file, 
	for ( my $i = 0 ; $i < $batch_id ; $i++ ) {
		# Line 1: output and input files
		my $operation =
		  "$tmpfolder/out_$i.txt: $tmpfolder/input/in_$i.txt \$APPBIN\n"; 
		#Line 2: main application command
		# Note GNRS options: 
		#	-a: api mode, no echo, use password
		#	-n: no header; critical or will lose one line per batch
		$operation .=
"\t\$APPBIN -a -n -f $tmpfolder/input/in_$i.txt -o $tmpfolder/out_$i.txt \n\n"; 
		$cmd = $cmd . $operation;
		$filelist .= "$tmpfolder/out_$i.txt ";
	}
	
	# Call to the consolidation script
	#$cmd .= "$tmpfolder/output.csv: $CONSOLIDATE_SCR $tmpfolder $filelist\nLOCAL $CONSOLIDATE_SCR $tmpfolder\n\n";
	$cmd .= "$tmpfolder/output.csv: $CONSOLIDATE_SCR $tmpfolder $filelist\n $CONSOLIDATE_SCR $tmpfolder $d\n\n";

	# Copy the consolidated output to the final destination
	#$cmd .= "$outfile: $tmpfolder/output.csv\nLOCAL cp $tmpfolder/output.csv $outfile\n\n";
	$cmd .= "$outfile: $tmpfolder/output.csv\n cp $tmpfolder/output.csv $outfile\n\n";

	# Write the file to the temporary folder
	open my $FF, ">$tmpfolder/${APPNAME}.flow"
	  or die("Cannot write makeflow file $tmpfolder/${APPNAME}.flow: $!\n");
	print $FF $cmd;
	close $FF;
}

# Write a batch of coordinates to a file in the temporary folder
sub _write_out {
	my $batch_id  = shift;
	my $batch     = shift;
	my $tmpfolder = shift;

	if ( !-e $tmpfolder ) {
		mkdir $tmpfolder
		  or die("Cannot create temporary folder $tmpfolder: $!\n");
		mkdir "$tmpfolder/input"
		  or die("Cannot create temporary folder $tmpfolder/input: $!\n");
	}
	
	# Batch files are stored in subfolder input
	$tmpfolder = "$tmpfolder/input"; 
	
	open( my $OF, ">$tmpfolder/in_$batch_id.txt" )
	  or die("Cannot write output file $tmpfolder/in_$batch_id.txt: $!\n");
	print $OF join( "\n", @{$batch} );
	close $OF;
}

#In case no files need to be written (Unused)
sub _write_screen {
	my $batch_id = shift;
	my @batch    = @{ shift() };
	for ( my $i = 0 ; $i < @batch ; $i++ ) {
		print "$batch_id.$i\t$batch[$i]\n";
	}

}

#Remove temporary files
#The tempfolder needs to be in the /tmp directory
sub _clean {
	my $td = shift;
	$td =~ s/^\/tmp//; 	#This is a failsafe to avoid accidentally deleting other relevant files.
	my $dummy = system("rm -rf /tmp$td");
}

#Dummy function, in case accepted names are to be treated differently
sub is_accepted {
	return 0;

}
