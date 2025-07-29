use strict;
use warnings;
use Test::More tests => 4;

BEGIN { use_ok('SOAP::Lite') };
 
ok( eval{ `perl ./footDBclient.pl -k myb` } =~ /EEADannot/ , 'keyword' );

ok( eval{ `perl ./footDBclient.pl -p sample/protein.faa` } =~ /EEADannot/ , 'peptide' );

ok( eval{ `perl ./footDBclient.pl -m sample/motif.tf` } =~ /EEADannot/ , 'motif' );
