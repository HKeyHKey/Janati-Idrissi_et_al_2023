#!/bin/sh

### Preparation of bait (gathering every pre-miRNA hairpin sequence from every member of the miR-202 family in any vertebrate in miRBase v.22.1):
wget ftp://mirbase.org/pub/mirbase/22.1/organisms.txt.gz
gunzip organisms.txt.gz
mv organisms.txt organismsOct18.txt
wget -O miRNAOct18.dat.gz https://mirbase.org/ftp/22.1/miRNA.dat.gz
gunzip miRNAOct18.dat.gz
grep Vertebrata organismsOct18.txt | awk -F '\t' '{OFS="\t";print $1,$3}' > vertebrate_species_in_miRBase.txt
for code in `awk -F '\t' '{print $1}' vertebrate_species_in_miRBase.txt`;do grep -A 1 '^>'$code'\-' matureOct18.fa;done | grep -v '\-\-' > vertebrate_miRNAs_in_miRBase.fa
seed=UCCUAU # this is the seed sequence (nt 2-7) of the miR-202 miRNA family
grep -B 1 '^[ACGU]'$seed vertebrate_miRNAs_in_miRBase.fa | grep -v '\-\-' > vertebrate_miRNAs_in_miRBase_for_seed_$seed'.fa'
./Module_hairpins_for_seed.pl vertebrate_miRNAs_in_miRBase_for_seed_$seed'.fa' hairpinOct18.fa miRNAOct18.dat > vertebrate_hairpins_for_seed_$seed'.fa'

### Blast'ing the 72 Teleostei + 1 Holostei genomes which had reached "Chromosome" assembly stage in November 2021 for every miRBase-annotated hairpin sequence for the miR-202 miRNA family:

mkdir Blasts_$seed
for sp in `grep -Pv '^Species\tAssembly\tSize' Teleostei_genomes_at_chromosome_assembly.tsv | awk -F '\t' '{print $1}' | sed 's| |_|g'` 
do blastn -query vertebrate_hairpins_for_seed_$seed'.fa' -db Genomes/$species'_genomic.fna' -word_size 6 -evalue 0.001 -outfmt "6 qseqid sseqid pident nident qstart qend sstart send evalue bitscore qseq sseq" > Blasts_$seed/blast_output_$seed'_in_'$species
done

### Selecting candidates with a canonical distance between miRNA seed and pre-miRNA loop:

WINDOW_SIZE=66 # length of sliding sequence windows to be folded
DELTA_G_CUTOFF=-14 # maximal accepted predicted Delta G for unbranched hairpin (in kcal/mol) among the most stable predicted structures for a given $WINDOW_SIZE ng-long subsequence
seed_T=`echo $seed | tr U T`
for file in `ls Blasts_$seed/`
do species=`echo $file | sed -e 's|^blast_output_'$seed'_in_||'`
	for ID in `sed 's|"||g' Convincing_NGS_profiles.csv | awk -F ',' '$2=="'$seed'" {print $3}'` # file 'Convincing_NGS_profiles.csv' contains miRBase miRNA identifiers for pre-miRNAs with a correct Small RNA-Seq profile (precise 5´ end, abundant miRNA reads with little alternative isoforms); for the miR-202 family, there are two such hairpins (both are for miR-202 rather than for another potential miRNA of the same family): hsa-miR-202 and mmu-miR-202
   do name=`grep ' '$ID' ' vertebrate_hairpins_for_seed_$seed'.fa' | sed -e 's|^>||' -e 's| .*||'`
      for candidate in `awk '$12~/'$seed_T'/ && $9<=1e-7 && $1=="'$name'" {print $12}' Blasts_$seed/$file | sed 's|-||g'` # selects candidates with a perfect, interrupted occurrence of the seed, and with a good blast hit (E-value <= 1e-7) to that NGS-profile-validated miRBase-annotated hairpin
      do l=`echo -n $candidate | wc -m`
         end=`echo $l"-"$WINDOW_SIZE"+1" | bc`
         if test $l -ge $WINDOW_SIZE # select candidates which are at least $WINDOW_SIZE nt long (I will search for unbranched hairpins in a sliding $WINDOW_SIZE nt-window)
         then for nt in `seq 1 $end`
              do last=`echo $nt"+"$WINDOW_SIZE"-1" | bc`
                 extract=`echo $candidate | cut -c $nt-$last`
                 echo $extract | RNAsubopt -e 3 | grep '^[\.(]*[\.)]* ' | awk '$2<='$DELTA_G_CUTOFF' {print}' | sed 's|^|'$extract' |'
              done
      else if test $l -ge 50 # for candidates shorter than $WINDOW_SIZE, but at least 50 nt long: do not fold a sliding window, but the whole sequence (and still with the same DeltaG cutoff: -14 kcal/mol).
              then extract=$candidate
                   echo $extract | RNAsubopt -e 3 | grep '^[\.(]*[\.)]* ' | awk '$2<='$DELTA_G_CUTOFF' {print}' | sed 's|^|'$extract' |'
              fi
         fi
      done
   done > candidates_$seed'_in_'$species
done

for species in `ls Blasts_$seed/blast_output_* | sed 's|^Blasts_'$seed'/blast_output_'$seed'_in_||'`
do ./Module_position_of_seed_in_hairpin.pl candidates_$seed'_in_'$species 16 23 2 11 > correct_seed_to_loop_distance_candidates_$seed'_in_'$species
done

for sp in `grep -Pv '^Species\tAssembly\tSize' Teleostei_genomes_at_chromosome_assembly.tsv | awk -F '\t' '{print $1}' | sed 's| |_|g'`
do awk '{print $1}' correct_seed_to_loop_distance_candidates_$seed'_in_'$sp
done | sort | uniq | nl | awk '{print ">Teleostei_"$1"\n"$2}' > Teleostei_candidate_hairpins_in_$seed'_family.fa'

# Blast'ing all 94 Teleostei genomes for these convincing Teleostei hairpin sequences for miR-202:

for sp in `ls Genomes/*_genome.fa.gz | sed -e 's|^Genomes/||' -e 's|_genome\.fa\.gz$||'`
do gunzip Genomes/$sp'_genome.fa.gz'
   makeblastdb -in Genomes/$sp'_genome.fa' -dbtype nucl
   blastn -db Genomes/$sp'_genome.fa' -query Teleostei_candidate_hairpins_in_$seed'_family.fa' -evalue 0.001 -word_size 12 -outfmt "6 qseqid sseqid pident nident qstart qend sstart send evalue qseq sseq" > Blast_output_$sp'.txt'
done

# Locating candidate mature miR-202 in these candidate mir-202 hairpins (using miRBase-annotated mature miR-202 as references):

egrep -A 1 "gmo-miR-202-3p|oni-miR-202|abu-miR-202|ssa-miR-202-3p|ipu-miR-202|dre-miR-202-5p" matureOct18.fa | grep -v '\-\-' > Teleostei_miR-202.fa
for name in `grep '>' Teleostei_miR-202.fa | sed -e 's|^>||' -e 's| .*||' -e 's|-[35]p$||' -e 's|miR|mir|'`;do grep -A 1 '^>'$name' ' Fused_hairpinOct18.fa;done > Teleostei_mir-202.fa 
for sp in `ls Blast_output_* | sed -e 's|Blast_output_||' -e 's|\.txt$||'` Lepisosteus_oculatus
do awk '{print ">"$2"_"$7"_"$8" "$11}' Blast_output_$sp'.txt' | sort | uniq | sed 's| |\
|' > tmp_hairpins_$sp'.fa'
   makeblastdb -in tmp_hairpins_$sp'.fa' -dbtype nucl
   blastn -db tmp_hairpins_$sp'.fa' -query Teleostei_miR-202.fa -word_size 6 -strand plus -evalue 0.001 -outfmt "6 qseqid sseqid pident nident qstart qend sstart send evalue qseq sseq" | awk '$5==1 {print $
2,$7,$8,$11}' | sed -e 's|_| |2' -e 's|_| |2' | awk '{if ($2<$3) print ">"$1"_bp_"$2+$4-1"-"$2+$5-1" "$6;else print ">"$1"_bp_"$2-$4+1"-"$2-$5+1" "$6}' | sort | uniq | sed 's| |\
|' > tmp_isoforms_$sp'.fa' # extracting presumptive mature miRNA from the identified hairpin hits (selecting those whose alignment starts at miRNA nt 1)
   ./Module_mature_isoform_size_selection.pl tmp_isoforms_$sp'.fa' 21 > miR-202_in_$sp'.fa' # For each genomic locus, selects the isoform whose length is closest to 21 (which is the dominant miR-202 isoform length in Danio rerio: see https://www.mirbase.org/cgi-bin/get_read.pl?acc=MI0002040 ); break ties by selecting the longest isoform if needed.
done

