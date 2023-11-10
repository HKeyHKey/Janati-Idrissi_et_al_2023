#!/usr/bin/perl

if ($ARGV[1] eq '')
{
    print "Please enter script arguments (fasta file, and sequence length to be matched as closely as possible; e.g., ./Module_mature_isoform_size_selection.pl tmp_isoforms_Anoplopoma_fimbria.fa 21).\n";
    exit;
}

open(FA,$ARGV[0]);
while(<FA>)
{
    chomp;
    if (/^>/)
    {
	s/^> *//;
	s/ .*//;
	$name=$_;
    }
    else
    {
	$seq{$name}=$seq{$name}.$_;
    }
}
close(FA);


for $name (keys %seq)
{
    $locus=$name;
    $locus=~s/-.*//;
    push(@loci,$locus);
}

@unique_loci = do { my %seen; grep { !$seen{$_}++ } @loci };

$optim_length=$ARGV[1];


for $locus (@unique_loci)
{
    $select='';
    $minimum='';
    for $name (keys %seq)
    {
	if ($name=~/^$locus-/)
	{
	    $distance{$name}=$optim_length-length($seq{$name});
	    if ($distance{$name}<0)
	    {
		$distance{$name}=-$distance{$name};
	    }
	    if (($distance{$name}<=$minimum) || ($minimum eq ''))
	    {
		if (($minimum eq '') || ($distance{$name}<$minimum) || (($distance{$name}==$minimum) && (length($seq{$name})>length($seq{$select})))) # if two sequence lengths diverge equally from $optim_length, select the longest one
		{
		    $select=$name;
		    $minimum=$distance{$name};
		}
	    }
	}
    }
    print ">$select\n$seq{$select}\n";
}
