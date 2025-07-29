
## footprintDB REST API

FootprintDB (https://footprintdb.eead.csic.es) is a database of curated regulatory sequences and their associated transcription factors (TFs).
It systematically annotates the binding interfaces of the TFs, the key residues responsible for specific binding, by exploiting protein-DNA 
complexes at the [Protein Data Bank](https://www.rcsb.org).

Each entry in footprintDB is thus a DNA motif linked to the protein sequence of the TF(s) known to recognize it, and in most cases, 
the set of predicted interface residues. It has been described at:
* https://doi.org/10.1093/bioinformatics/btt663
* https://link.springer.com/protocol/10.1007%2F978-1-4939-6396-6_17
* https://link.springer.com/chapter/10.1007/978-3-642-28062-7_8

The footprintDB database is also intergrated with [RSAT](rsat.eu), please see https://github.com/rsa-tools/motif_databases

This repo documents a REST interface for users wanting to programatically match their own protein sequence against footprintDB.

The actual server code is in file [rest_server.pl](./rest_server.pl) and requires Perl module 
[Mojolicious::Lite](https://metacpan.org/pod/Mojolicious::Lite).

The URL of the production server is http://footprintdb.eead.csic.es:8080/protein 

## Example query

To query the API you need [curl](https://curl.se) and one or more protein sequences (queries) in JSON format:

    curl -X POST -H "Content-Type: application/json" -d '{"q1":"MVAKVKRDGEVLVAAATGDSEEQDDLVLPGFRFHPTDEELVTFYLRRKVARKPLSMEIIKEMDIYKHDPWDLPKASTVGGEKEWYFFCLRGRKYRNSIRPNRVTGSGFWKATGIDRPIYPAAAGESVGLKKSLVYYRGSAGKGAKTDWMMHEFRLPPAASSPSTQEAVEVWTICRIFKRNIAYKKRQPAGSNAPPPPLAESSSNTGSFESGGGGDDGEYMNCLPVPVPATAAVVPRQQHRIGSMLNGGGVTASGSSFFREVGVHGQQFQGHWLNRFAAPEIERKPQLLGSSAMTIAFHQNDQTAATNECYKDGHWDEIARFMEVNDPTVLYDCRYA","q2":"IYNLSRRFAQRGFSPREFRLTMTRGDIGNYLGLTVETISRLLGRFQKSGMLAVKGKYITIEN"}' http://footprintdb.eead.csic.es:8080/protein

This will produce text output in TRANSFAC format, with max 5 matches for each input sequence:

    AC  protein_query:q1 match:1
    XX
    ID  q1|NAC74|EEADannot 2025-07-22
    XX
    DT  29.07.2025 (predicted)
    XX
    NA  EEAD0487
    XX
    DE  EEAD0487
    XX
    OS  Zea mays
    XX
    BF  ZmNAC74;NACTF74;GRMZM2G112548_T01; Species: Zea mays
    XX
    PO      A      C      G      T
    01  0.242  0.482  0.139  0.137      c
    02  0.335  0.039  0.593  0.033      r
    03  0.447  0.045  0.430  0.078      r
    04  0.000  0.472  0.000  0.528      y
    05  0.112  0.000  0.831  0.057      G
    06  0.122  0.513  0.342  0.023      s
    07  0.018  0.982  0.000  0.000      C
    08  0.001  0.000  0.999  0.000      G
    09  0.002  0.000  0.186  0.812      T
    10  0.228  0.218  0.428  0.126      g
    11  0.186  0.374  0.280  0.160      s
    XX
    CC  footprintDB match: BLASTP e-value=0.0 interface identity=8/8 similarity=8/8
    CC  footprintDB Pfam domains: PF02365 (No apical meristem (NAM) protein)
    CC  footprintDB library: EEADannot 2025-07-22
    XX
    LN  https://footprintdb.eead.csic.es/index.php?tf=21873
    XX
    //
    AC  protein_query:q2 match:1
    XX
    ID  q2|ECK120004795|RegulonDB 7.5
    XX
    DT  29.07.2025 (predicted)
    XX
    NA  FNR
    XX
    DE  FNR
    XX
    OS  ECK12
    XX
    BF  FNR; Species: ECK12
    XX
    PO      A      C      G      T
    01     17      8     10     48      t
    02      5      8      6     64      T
    03     13     10     58      2      G
    04     47     14      8     14      a
    05     10      3     13     57      T
    06     17     28      3     35      y
    07     28     10     16     29      w
    08     48     12     11     12      a
    09     20     23     11     29      y
    10     66      0     11      6      A
    11      4      0      0     79      T
    12      0     72      5      6      C
    13     80      1      0      2      A
    14     73      8      0      2      A
    XX
    CC  footprintDB match: BLASTP e-value=2e-38 interface identity=8/8 similarity=8/8
    CC  footprintDB Pfam domains: PF13545 (Crp-like helix-turn-helix domain) / PF00325 (Bacterial regulatory proteins, crp family)
    CC  footprintDB library: RegulonDB 7.5
    XX
    LN  https://footprintdb.eead.csic.es/index.php?tf=5989
    XX
    //


## Deprecated SOAP API

On March 2023 the original SOAP Web Services interface was deprecated, you can still check the relevant files at [old.SOAP](./old.SOAP).
