## [This API was deprecated on March 2023]

The footprintDB server moved to https://footprintdb.eead.csic.es from its old server https://floresta.eead.csic.es/footprintdb.
During that process we decided to deprecate the SOAP Web Services interface.

## Legacy content

FootprintDB (http://floresta.eead.csic.es/footprintdb) is a database of regulatory sequences from open access libraries of curated DNA cis-elements and motifs, and their associated transcription factors (TFs). 

It systematically annotates the binding interfaces of the TFs by exploiting protein–DNA complexes deposited in the [Protein Data Bank](https://www.rcsb.org). Each entry in footprintDB is thus a DNA motif linked to the protein sequence of the TF(s) known to recognize it, and in most cases, the set of predicted interface residues involved in specific recognition. It has been described at:
* https://doi.org/10.1093/bioinformatics/btt663
* https://link.springer.com/protocol/10.1007%2F978-1-4939-6396-6_17
* https://link.springer.com/chapter/10.1007/978-3-642-28062-7_8

The script [footDBclient.pl](./footDBclient.pl) is for users wishing to query footprintDB from the command-line through the Web Services interface. This was first described in our [blog](https://bioinfoperl.blogspot.pt/2017/10/soap-interface-of-footprintdb.html).

## Dependencies 

It uses Perl5 module SOAP::Lite, at https://metacpan.org/pod/SOAP::Lite, which can be 
installed with 

	sudo cpan -i SOAP::Lite

## Notes

The script can be used to make serial queries, one input at a time. By default, queries are spaced 30s to avoid overloading the server.

