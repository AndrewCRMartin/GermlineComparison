#!/usr/bin/perl

use strict;

while(<>)
{
    chomp;
    my @fields = split;

    my $seq1 = $fields[0];
    my $seq2 = $fields[2];
    my $sim  = $fields[4];
    my $id   = $fields[6];

    print "$seq1 $seq2 $sim $id\n";
}

    
    
