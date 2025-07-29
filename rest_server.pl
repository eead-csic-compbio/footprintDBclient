#!/usr/bin/env perl
use strict;
use File::Temp qw/ tempfile /;
use Mojolicious::Lite;

# REST server to support protein queries to footDB and replace old Web Services SOAP interface.
# Returns text with predicted motifs in TRANSFAC format.
#
# Launch:
# ./rest_server.pl daemon --listen http://161.111.227.27:8080
# Client query:
# curl -X POST -H "Content-Type: application/json" -d '{"q1":"MVAKVK..","q2":"IYNLSRR.."}' http://footprintdb.eead.csic.es:8080/protein

# July2025 B Contreras EEAD-CSIC

my $MAXSEQS = 1000;
my $AASEARCHEXE = 'bin/search_footprintdb.pl -b -be 1E-10 -l 5';

## test, example of route to handle GET request
get '/test' => sub {
  my $c = shift();
  $c->render(json => { message => 'Waiting for requests!' });
};

## echo, example of route to handle POST request
post '/echo' => sub {
  my $c = shift();
  my $data = $c->req->json();

  $c->render(json => { received => $data });
};

## protein, POST request to annotate 1+ protein sequences
post '/protein' => sub {
  my $c = shift();
  my $data = $c->req->json();

  my ($output,$n_seqs,$name) = ('',0);
  my ($outf1,$outf2,$outf3,$outf4,$outf5);

  # write input sequences to temp file
  my ($tmpfh, $tmpfilename) = tempfile();
  foreach my $name (keys(%$data)) {

    if($n_seqs > $MAXSEQS) {
      $output .= "# too many sequences, skip $name\n";

    } elsif($data->{$name} =~ /^[ACGTUXN\-\s]+$/i) {
      $output .= "# nucleotide sequence, skip $name\n";
      next;
    }	  

    print $tmpfh ">$name\n$data->{$name}\n";
    $n_seqs++;
  }
  close($tmpfh);

  # scan input sequences and parse contents of TRANSFAC file as main output
  open(AASEARCH,"$AASEARCHEXE -i $tmpfilename |") || 
    $c->render(text => "# ERROR: protein search failed\n");
  while(<AASEARCH>) {

    if(/Extracting TF sequences in FASTA format from database into '([^']+)'/){
      $outf1 = $1

    } elsif(/Processing '([^']+)' Blast alignments/){
      $outf2 = $1

    } elsif(/# BlastP results saved in '([^']+)', '([^']+)', '([^']+)'/) {
      ($outf3,$outf4,$outf5) = ($1,$2,$3);	    
      open(TRANSFAC,"<",$outf5) ||
        $c->render(text => "# ERROR: cannot read TRANSFAC file $outf5\n");
      while(<TRANSFAC>) {
        $output .= $_;
      }
      close(TRANSFAC);      
    } 
  }
  close(AASEARCH);

  # remove results
  unlink($outf1,$outf2,$outf3,$outf4,$outf5,$tmpfilename,$tmpfilename."2.fa");

  $c->render(text => $output)
};

app->start();
