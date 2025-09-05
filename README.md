GermlineComparison
==================

**(c) Andrew C.R. Martin, September 2025**

This is a quick script that takes HTML from IMGT containing sequences
of germline segments for two different species and does and all-by-all
comparison of the sequences to establish an overall mean identity (or
similarity) between the germlines of the two species.

For example, the HTML from:
https://www.imgt.org/3Dstructure-DB/cgi/DomainDisplay.cgi?modif=1&species=Oryctolagus+cuniculus&patternespece=&ReceptorType=IG&patternRecType=&groups=IGHV&patternGroup=&subgroups=any&patternSubgroup=&genes=any&patternGene=&alleles=any&patternAllele=&seldomtype=V&seldomnum=&selaccnum=&showallele=all&fonctional=on&shownbseq=all&Show=Show&colorseq=1&difference=none&separespecie=none&separegroup=none&separesubgroup=none&separegene=none&separedomain=name&repeatheaddomain=true#results

The code extracts the sequence data from the HTML files and writes
each pair of sequences as FASTA files which are then compared using my
`nw` program.

