#!/usr/bin/perl

if ($ARGV[1] eq '')
{
    print "Please enter script arguments (fasta file with mRNA sequences, and text file giving position of 3´ UTR starts; e.g., ./Module_longest_UTR.pl Tead3b_ortholog_transcripts.fa 3p_UTR_starts_in_Tead3b_ortholog_transcripts.fa.txt).\n";
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
	$acc=$_;
    }
    else
    {
	$seq{$acc}=$seq{$acc}.$_;
    }
}
close(FA);

open(TXT,$ARGV[1]);
while(<TXT>)
{
    chomp;
    if ($_ ne 'Accession_number GI_number Start_of_3p_UTR')
    {
	($species,$acc,$gi,$start)=split(' ',$_);
	$extract=substr $seq{$acc},$start-1;
	if ((length($extract)>$max{$species}) || ($max{$species} eq ''))
	{
	    $longest_UTR{$species}=">$species $acc (bp $start and further)\n$extract\n";
	    $max{$species}=length($extract);
	}
    }
}
close(TXT);

for $species (keys %longest_UTR)
{
    if ($max{$species})
    {
	print "$longest_UTR{$species}";
    }
}
