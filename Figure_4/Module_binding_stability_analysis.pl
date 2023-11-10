#!/usr/bin/perl
use List::Util qw(min);

if ($ARGV[2] eq '')
{
    print "Please enter script inputs: FASTA file with UTR sequences, then CSV file describing binding site location, then miRNA sequence (e.g., ./Module_binding_stability_analysis.pl Medaka_3p_UTRs.fa ../Differentially_expressed_TargetScan_predicted_targets_at_stage_EV.csv UUCCUAUGCAUAUACUUCUUU).\n";
    die;
}

$CONTEXT_5p=20; # number of nt to be extracted 5´ of the identified seed match (in order to pair it to the miRNA sequence)
$CONTEXT_3p=3; # number of nt to be extracted 3´ of the identified seed match (in order to pair it to the miRNA sequence)
open(FA,$ARGV[0]);
while(<FA>)
{
    chomp;
    if (/^>/)
    {
	s/^> *//;
	@array=split('\|',$_);
	($gene,$transcript_version)=($array[0],$array[3]);
	push(@{$transcripts_for_gene{$gene}},$transcript_version);
#	$gene_ID{$transcript_version}=$gene;
    }
    else
    {
	if ($_ ne 'Sequence unavailable')
	{
	    $seq{$transcript_version}=$seq{$transcript_version}.$_;
	}
    }
}
close(FA);

print "Gene Gene_name Site DeltaG\n";
open(CSV,$ARGV[1]);
while(<CSV>)
{
    chomp;
    if ($_ ne 'n° ensembl,gene_name,mir202_hits_8mer,mir202_hits_7mer,mir202_hits_6mer')
    {
	@array=split(',',$_);
	($gene,$gene_name,$sites[0],$sites[1],$sites[2])=($array[0],$array[1],$array[2],$array[3],$array[4]);
	if ($gene_name eq '')
	{
	    $gene_name='NA';
	}
	for $site_type (0,1,2)
	{
	    if ($sites[$site_type] ne '')
	    {
		@array2=split(';',$sites[$site_type]);
		for $site (@array2)
		{
		    @deltaG=();
		    @extracts=();
		    $site=~s/^ *//;
		    @array3=split('_',$site);
		    ($site_length,$site_start,$site_end)=($array3[1],$array3[2],$array3[3]);
		    #		    print  "   site=$site length=$site_length start=$site_start end=$site_end\n";
		    for $transcript (@{$transcripts_for_gene{$gene}})
		    {
			$extract=substr $seq{$transcript},$site_start-1-$CONTEXT_5p,$site_end-$site_start+1+$CONTEXT_5p+$CONTEXT_3p;
			if ($extract) # ignores empty extracts (e.g., when the 3´ UTR for that transcript isoform did not reach the site)
			{
			    push(@extracts,$extract);
			}
		    }
		    my @unique = do { my %seen; grep { !$seen{$_}++ } @extracts };
		    for $target_site (@unique)
		    {
		        open(TMP,">tmp_for_RNAduplex.fa");
			print TMP ">miRNA\n$ARGV[2]\n>target\n$target_site\n";
			close(TMP);
			if ($gene eq 'ENSORLG00000006370')
			{
			    `cp tmp_for_RNAduplex.fa miR-202_and_Tead3b_site_for_RNAduplex.fa`;
			}
			$out=`RNAduplex < tmp_for_RNAduplex.fa | grep -v '^>'`;
			$out=~s/.* +\( *([\d\.-]*)\)\n/\1/;
			push(@deltaG,$out);
		    }
		    $min_deltaG=min(@deltaG); # extract the lowest predicted DeltaG across all annotated transcript isoforms for that site
		    print "$gene $gene_name $site $min_deltaG\n";
		}
	    }
	}
    }
}
close(CSV);
