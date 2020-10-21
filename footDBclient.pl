#!/usr/bin/env perl

# This script allows you to query http://floresta.eead.csic.es/footprintdb
# from the command-line. It uses Perl module SOAP::Lite, which can be 
# installed with $ sudo cpan -i SOAP::Lite

use strict;
use warnings;
use Getopt::Std; 
use SOAP::Lite;

my $WAIT = 20; # wait time between jobs
my $KWTYPE = 'all';

my %opts;
my ($username,$input,$server) = ('','');

getopts('hu:m:p:k:', \%opts);

if(($opts{'h'})||(scalar(keys(%opts))==0))
{
	print "\nusage: $0 [options]\n\n";
	print "-h this message\n";
	print "-m motif file in TRANSFAC format, example: -m matrix.tf\n";
	print "-p peptide sequence in FASTA format, example: -p sequence.faa\n";
	print "-k keyword for text query, example: -k myb\n";
	print "-u registered footprintDB username, optional\n\n";
	exit(-1);
} 

if(!defined($opts{'m'}) && !defined($opts{'p'}) && !defined($opts{'k'})){ 
	print "# ERROR: choose one of -m, -p -or -k\n";
	exit(1);
}
else { # prepare Web Services connection
	$server = SOAP::Lite
		-> uri('footprintdb')
		-> proxy('http://floresta.eead.csic.es/footprintdb/ws.cgi');
}

if(defined($opts{'u'})){ $username = $opts{'u'} }

#############################

my ($result,$sequence,$name,$datatype,$keyword) = ('','','','','');

if(defined($opts{'p'})){

	# read input FASTA file
	my (%fasta,@names);
	open(FASTA,"<",$opts{'p'}) || 
		die "# ERROR: cannot read $opts{'p'}\n";
	while(<FASTA>){
		if(/^>\s*(\S+)/){ 
			$name = $1; 
			push(@names,$name);
		}
		else {
			chomp;
			$sequence = $_;
			$fasta{$name} .= $sequence;
		}
	}
	close(FASTA);

	# process sequences, one at a time, waiting in between
	foreach $name (@names){

		$sequence = $fasta{$name};
		$result = $server->protein_query($name,$sequence,$username);
		
		unless($result->fault()){
			print $result->result(); 
		} else {
			print '# ERROR: ' . join(', ',$result->faultcode(),$result->faultstring());
		}

		sleep($WAIT);
	}
}
elsif(defined($opts{'m'})){

	# read motif file
	my (%transfac,@names);
	open(TF,"<",$opts{'m'}) ||
		die "# ERROR: cannot read $opts{'m'}\n";
	while(<TF>){
		if(/^DE\s*(\S+)/){
			$name = $1;
			push(@names,$name);
		}
		else {
			chomp;
			$sequence = $_;
			$transfac{$name} .= $sequence;
		}
	}
	close(TF);

	# process motifs, one at a time, waiting in between
	foreach $name (@names){

		$result = $server->DNA_motif_query($name,$sequence,$username);
		unless($result->fault()){
			print $result->result();
		} else {
			print '# ERROR: ' . join(', ',$result->faultcode(),$result->faultstring());
		}

		sleep($WAIT);
	}
}
elsif(defined($opts{'k'})){

	$keyword = $opts{'k'};
	$datatype = $KWTYPE;

	$result = $server->text_query($keyword,$datatype,$username);
	unless($result->fault()){
		print $result->result();
	} else {
		print 'error: ' . join(', ',$result->faultcode(),$result->faultstring());
	}
}

exit(0);
