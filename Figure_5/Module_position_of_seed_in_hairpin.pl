#!/usr/bin/perl



if ($ARGV[4] eq '')
{
    print "Please enter script arguments (name of text file containing candidate structure information, then: minimal then maximal number of bp between seed and loop for 5´-arm miRNAs, then for 3´-arm miRNAs; e.g., ./Module_position_of_seed_in_hairpin.pl candidates_UGUAUG_in_Mirounga_leonina 16 23 2 11).\n";
    exit;
}

$seed=$ARGV[0];
$seed=~s/.*candidates_//;
$seed=~s/_in_.*//;
$seed=~tr/U/T/;

open(IN,$ARGV[0]);
while(<IN>)
{
    chomp;
    @array=split(' ',$_);
    ($seq,$str)=($array[0],$array[1]);
    
    @hits=();
    $offset=0;
    $result=index($seq,$seed,$offset);
    while ($result != -1)
    {
	push(@hits,$result);
	$offset=$result+1;
	$result=index($seq,$seed,$offset);
    }
    ($arm5,$arm3)=($str,$str);
    $arm5=~s/[\.\)]*$//;
    $arm3=~s/^[\.\(]*//;
    $loop5=length($arm5);
    $loop3=length($str)-length($arm3)-1;
    $extr=substr $str,$loop5,$loop3-$loop5+1;
    $selected=0;
    for $hit (@hits)
    {
	if ($hit<$loop5)
	{
	    $extract=substr $arm5,$hit;
	    $d2=0;
	    for $char (split('',$extract))
	    {
		if ($char eq '(')
		{
		    ++$d2;
		}
	    }
	    if (($d2>=$ARGV[1]) && ($d2<=$ARGV[2]))
	    {
		$selected=1;
	    }
	}
	elsif ($hit>$loop3)
	{
	    $extract=substr reverse($arm3),$loop3-$hit;
	    $d2=0;
	    for $char (split('',$extract))
	    {
		if ($char eq ')')
		{
		    ++$d2;
		}
	    }
	    if (($d2>=$ARGV[3]) && ($d2<=$ARGV[4]))
	    {
		$selected=1;
	    }
	}
    }
    if ($selected)
    {
	print "$_\n";
    }
}
close(IN);
