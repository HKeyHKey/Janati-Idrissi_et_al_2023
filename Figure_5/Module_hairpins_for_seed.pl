#!/usr/bin/perl

if ($ARGV[2] eq '')
{
    print "Please enter input file names (e.g., ./Module_hairpins_for_seed.pl vertebrate_miRNAs_in_miRBase_for_seed_AGCUUA.fa hairpinOct18.fa miRNAOct18.dat).\n";
    die;
}

open(CORRESP,$ARGV[2]);
while(<CORRESP>)
{
    chomp;
    if (/^AC /)
    {
	s/^AC *//;
	s/;$//;
	$ID=$_;
    }
    if (/accession="MIMAT/)
    {
	s/.*accession="MIMAT/MIMAT/;
	s/"$//;
	$hairpin{$_}=$ID;
    }
}
close(CORRESP);

open(HAIRPINS,$ARGV[1]);
while(<HAIRPINS>)
{
    chomp;
    if (/^>/)
    {
	($ID,$name)=($_,$_);
	$ID=~s/.* (MI[0-9]+) .*/\1/;
	$hairpin_name{$ID}=$name;
    }
    else
    {
	$hairpin_seq{$ID}=$hairpin_seq{$ID}.$_;
    }
}
close(HAIRPINS);

open(MATURE,$ARGV[0]);
while(<MATURE>)
{
    chomp;
    if (/^>/)
    {
	s/.* (MIMAT[0-9]+) .*/\1/;
	push(@ified_selected,$hairpin{$_});
    }
}
close(MATURE);

@selected = do { my %seen; grep { !$seen{$_}++ } @ified_selected };
for $ID (@selected)
{
    print "$hairpin_name{$ID}\n$hairpin_seq{$ID}\n";
}
