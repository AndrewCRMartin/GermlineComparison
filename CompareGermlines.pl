#!/usr/bin/perl

use strict;

my $html1 = shift(@ARGV);
my $html2 = shift(@ARGV);

my $aData1 = ReadGermline($html1);
my $aData2 = ReadGermline($html2);

my $label1 = $html1;
$label1 =~ s/\..*?$//; # Strip the extension

my $label2 = $html2;
$label2 =~ s/\..*?$//; # Strip the extension

my $faaFile1;
my $faaFile2;

my $totSim = 0;
my $totID  = 0;
my $count  = 0;

my $tdir = "/tmp/cgl" . $$ . time();
`mkdir $tdir`;
die "Can't create $tdir" if(! -d $tdir);

foreach my $data1 (@$aData1)
{
    my($id, $seq) = split(/\n/, $data1);
    $id =~ s/\>/_/;   # Replace the leading > in the ID with _
    $seq =~ s/\*/ /g; # Replace * in the sequence with ' '
    my $faaFile1 = "$tdir/$label1$id.faa";
    if(! -f $faaFile1)
    {
        if(open(my $out, '>', "$faaFile1"))
        {
            $id =~ s/_/\>/;   # Restore the leading >
            print $out "$id\n";
            print $out "$seq\n";
            close $out;
        }
    }

    foreach my $data2 (@$aData2)
    {
        my($id, $seq) = split(/\n/, $data2);
        $id =~ s/\>/_/;   # Replace the leading > in the ID with _
        $seq =~ s/\*/ /g; # Replace * in the sequence with ' '
        $faaFile2 = "$tdir/$label2$id.faa";
        if(! -f $faaFile2)
        {
            if(open(my $out, '>', "$faaFile2"))
            {
                $id =~ s/_/\>/;   # Restore the leading >
                print $out "$id\n";
                print $out "$seq\n";
                close $out;
            }
        }

        my ($File1, $File2, $sim, $id) = Compare($faaFile1, $faaFile2);

        print "$File1 vs. $File2 Sim: $sim ID: $id\n";
        $totSim += $sim;
        $totID  += $id;
        $count++;
        
        unlink($faaFile2);
        
    }
    unlink($faaFile1);
}

`rm -rf $tdir`;

printf "Average similarity: %.2f\%", $totSim / $count;
printf "Average ID:         %.2f\%", $totID  / $count;

sub Compare
{
    my($faaFile1, $faaFile2) = @_;

    my $result = `nw -f '$faaFile1' '$faaFile2'`;

    $result =~ m/HOMOL: (.*?)\%/;
    my $sim = $1;

    $result =~ m/IDNOTAIL: (.*?)\%/;
    my $idnotails = $1;

    $faaFile1 =~ s/^.*\///;
    $faaFile1 =~ s/\..*?$//;
    $faaFile2 =~ s/^.*\///;
    $faaFile2 =~ s/\..*?$//;

    return($faaFile1, $faaFile2, $sim, $idnotails);

}

sub ReadGermline
{
    my ($filename) = @_;
    my @Data = ();

    if(open(my $fp, '<', $filename))
    {
        while(<$fp>)
        {
            if(/collier_perles_allele/)
            {
                s/<.*?>//g;             # Remove all tags
                s/(^.*\*\d\d)/\>$1\n/;  # Add > at start and a LF after the identifier
                s/[ \.]//g;             # Strip spaces and full stops
                push @Data, $_;
            }
        }
        close ($fp);
    }
    return(\@Data);
}
