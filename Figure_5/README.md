## Tead3b ortholog sequence data in Teleostei ##

Download of Tead3b ortholog sequences in Teleostei from [NCBI](https://www.ncbi.nlm.nih.gov/gene/794293/ortholog/?scope=32443) into a file named 'Tead3b_ortholog_transcripts.fa' (contains 565 sequences, from 95 Teleostei species: there can be several RefSeq transcripts per species). Removing non-Unix end-of-line characters then downloading coding sequence (CDS) coordinates within each of these 565 mRNA sequences:
``sed -i 's|\r||' Tead3b_ortholog_transcripts.fa;./Script_download_CDS_coordinates.sh Tead3b_ortholog_transcripts.fa``

## Alignment of the longest 3´ UTR isoforms in Teleostei ##

Extraction of the longest 3´ UTR isoform (among RefSeq mRNA sequences) for each species:

``./Module_longest_UTR.pl Tead3b_ortholog_transcripts.fa 3p_UTR_starts_in_Tead3b_ortholog_transcripts.fa.txt > Longest_UTR_for_Tead3b_orthologs.fa``

Out of 95 species, only 94 are in 'Longest\_UTR\_for\_Tead3b\_orthologs.fa' (for the remaining one, _Chanos chanos_, the longest 3´ UTR isoform is 0-bp long: that's the 3´ UTR in XM\_030777444.1).

Sequence alignment:
``clustalw Longest_UTR_for_Tead3b_orthologs.fa;grep -n Oryzias Longest_UTR_for_Tead3b_orthologs.aln | grep GTGGACACTAAATGGAATATGTGTTACATAGGATTTTTGTTTC`` (the medaka site is in line 4341 of 'Longest\_UTR\_for\_Tead3b\_orthologs.aln')

``nl Longest_UTR_for_Tead3b_orthologs.aln | head -4450 | sed -e '/^ *4371\t/,$ d' -e '1,/^ *4276\t/ d' | grep -v '^ *$' | awk '{print ">"$2"\n"$3}' > Orthologous_Teleostei_tead3b_sites.fa``


## Addition of Holostei 3´ UTR orthologs ##

_N.B._: Holostei did not undergo the Teleostei-specific genome duplication, hence there is no "Tead3a" and "Tead3b" to look for here, but a unique "Tead3".

* In _Lepisosteus oculatus_: the gene named "Tead3a" seems to be the ortholog of O. latipes Tead3b (it is [syntenic to smpd2a](https://www.ncbi.nlm.nih.gov/gene/?term=Lepisosteus+oculatus+%5Borgn%5D+tead3) while the _O. latipes_ Tead3b locus is [syntenic to smpd2b](https://www.ncbi.nlm.nih.gov/gene/101169194)).
* In _Amia calva_: no obvious ortholog, either by searching gene name "Tead" in [NCBI "gene" database](https://www.ncbi.nlm.nih.gov/gene/?term=) or by a blast search using _O. latipes_ or _L. oculatus_ mRNA sequences as baits).

Extraction of the longest 3´ UTR isoform for _L. oculatus_ Tead3a: download of L. oculatus Tead3a mRNA isoform sequences from [NCBI "gene" database](https://www.ncbi.nlm.nih.gov/datasets/gene/id/102684909/products/) (file saved as 'rna.fna'), then:

``./Script_download_CDS_coordinates.sh rna.fna;./Module_longest_UTR.pl rna.fna 3p_UTR_starts_in_rna.fna.txt >> Longest_UTR_for_Lepisosteus_oculatus_Tead3b_ortholog.fa``

Annotated _L. oculatus_ Tead3a mRNA sequences have suspiciously short 3´ UTRs (that longest isoform is only 112 nt long). Extracting the _L. oculatus_ genomic sequence downstream of the Tead3a stop codon (from [GenBank's NC\_023181.1 sequence](https://www.ncbi.nlm.nih.gov/nuccore/NC_023181.1/?report=fasta), saved as 'NC\_023181.1.fa'):

``grep -n GAGGTCCTTGTGAGAAGT NC_023181.1.fa`` (the Tead3a 3´ UTR starts at line 335820 of 'NC\_023181.1.fa')

``echo ">extract_NC_023181.1.fa" > extract_genome.fa;tail -n +335820 NC_023181.1.fa | head -100 >> extract_genome.fa;./Fuses_lines_clean.pl extract_genome.fa | sed 's|.*\(..............................CATAGGA.............\).*|\1|' > candidate_ortholog_L_oculatus.fa`` (there is 1 occurence of the miR-202 7mer-m8 match in that genomic extract)

``cat Orthologous_Teleostei_tead3b_sites.fa candidate_ortholog_L_oculatus.fa | sed 's|extract_NC_023181.1.fa|Lepisosteus_oculatus|' > for_alignment_Teleostei_Holostei.fa;clustalw for_alignment_Teleostei_Holostei.fa``

The miR-202 7mer-m8 match is conserved between Teleostei and _L. oculatus_: flanking sequences also align well.

## Extraction of candidate miR-202 sequences in the 96 species of interest ##

Download of the 95 genomes of interest (94 Teleostei, because _Chanos chanos_ is not analyzable, and 1 Holostei: _Lepisosteus oculatus_):
``./Script_genome_download.sh``

Extracting candidate miR-202 mature sequences from these 95 genomes by homology search:
``./Script_miR-202_candidates_per_species.sh``

Resulting candidate mature miR-202 sequences per species are in archive 'Candidate\_mature\_miR-202\_per\_species.tar.bz2'.


## Listing species with or without a conserved site at the orthologous position of the functional Oryzias latipes site ##

``grep -n Oryzias for_alignment_Teleostei_Holostei.aln | grep CATAGGA`` (the medaka site is in line 1587 of 'for\_alignment\_Teleostei\_Holostei.aln')

``nl for_alignment_Teleostei_Holostei.aln | sed -e '/^ *1633\t/,$ d' -e '1,/^ *1537\t/ d' | grep -v '^ *$' | awk '{print ">"$2"\n"$3}' > Orthologous_tead3b_sites.fa``

## Heatmap tracing ##

(See software requirements at https://github.com/Nazim-Mechkouri/miR-202-in-Teleostei )

``mkdir candidates;mkdir candidates/candidates_tead3b;mkdir orthologous/;mkdir orthologous/orthologous_tead3b;mv miR-202_in_*.fa candidates/candidates_tead3b/;mv Orthologous_tead3b_sites.fa ../orthologous/orthologous_tead3b/;./script_launcher.sh tead3b``

Then re-order rows (swapping nodes) in the generated newick file if needed; then:
``wget https://www.genomicus.bio.ens.psl.eu/genomicus-fish-04.02/data/SpeciesTree.nwk;sed -e 's|)[A-Za-z0-9_]*:|):|g' -e 's|)[A-Za-z ]*;|);|' SpeciesTree.nwk > Genomicus_tree_filtered.nwk;./script_Dataframe_treatment.sh tead3b``

Resulting newick file (named 'tead3b\_small\_cladogram.newick') can be edited to re-order rows (swapping nodes). The (potentially edited) newick file is then fed to the next script:

``./script_Dataframe_treatment.sh tead3b tead3b_small_cladogram.newick``

Resulting heatmaps (in SVG format) are stored in directory "output/tead3b\_outputs/Heatmaps\_and\_Trees/".
