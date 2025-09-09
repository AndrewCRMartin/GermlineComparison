#!/usr/bin/perl

use strict;

my %bestid1  = ();
my %bestid2  = ();
my %bestsim1 = ();
my %bestsim2 = ();

my %bestid1Gene  = ();
my %bestid2Gene  = ();
my %bestsim1Gene = ();
my %bestsim2Gene = ();

while(<>)
{
    if(! /^Average/)
    {
        chomp;
        my @fields = split;
        
        my $seq1 = $fields[0];
        my $seq2 = $fields[2];
        my $sim  = $fields[4];
        my $id   = $fields[6];
        
        # If the key isn't defined or the value is better than the current
        # best for this key, then update it
        if((!defined($bestid1{$seq1})) || ($id > $bestid1{$seq1}))
        {
            $bestid1{$seq1} = $id;
            $bestid1Gene{$seq1} = $seq2;
        }
        if((!defined($bestid2{$seq2})) || ($id > $bestid2{$seq2}))
        {
            $bestid2{$seq2} = $id;
            $bestid2Gene{$seq2} = $seq1;
        }
        
        if((!defined($bestsim1{$seq1})) || ($sim > $bestsim1{$seq1}))
        {
            $bestsim1{$seq1} = $sim;
            $bestsim1Gene{$seq1} = $seq2;
        }
        if((!defined($bestsim2{$seq2})) || ($sim > $bestsim2{$seq2}))
        {
            $bestsim2{$seq2} = $sim;
            $bestsim2Gene{$seq2} = $seq1;
        }
    }
}


# We now have the best identities and similarities for each sequence
# Print them and get the species names

my $species1 = '';
my $meanSim1 = 0;
my $meanID1  = 0;
my $count1   = 0;
foreach my $key (sort keys %bestid1)
{
    ($species1) = split(/_/, $key) if($species1 eq '');
    print "$key BestSim: $bestsim1{$key} ($bestsim1Gene{$key}) BestID: $bestid1{$key} ($bestid1Gene{$key})\n";
    $meanSim1 += $bestsim1{$key};
    $meanID1  += $bestid1{$key};
    $count1++;
}

my $species2 = '';
my $meanSim2 = 0;
my $meanID2  = 0;
my $count2   = 0;
foreach my $key (sort keys %bestid2)
{
    ($species2) = split(/_/, $key) if($species2 eq '');
    print "$key BestSim: $bestsim2{$key} ($bestsim2Gene{$key}) BestID: $bestid2{$key} ($bestid2Gene{$key})\n";
    $meanSim2 += $bestsim2{$key};
    $meanID2  += $bestid2{$key};
    $count2++;
}

# Now calculate and print the averages
$meanSim1 /= $count1;
$meanSim2 /= $count2;
$meanID1  /= $count1;
$meanID2  /= $count2;

print "\n\n";
printf "Mean best matches for $species1 Sim: %.2f ID: %.2f\n", $meanSim1, $meanID1;
printf "Mean best matches for $species2 Sim: %.2f ID: %.2f\n", $meanSim2, $meanID2;

