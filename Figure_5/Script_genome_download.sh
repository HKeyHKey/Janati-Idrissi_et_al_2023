#!/bin/sh

# For the Holostei genome of interest (_Lepisosteus oculatus_) as well as for the 72 Teleostei genomes having reached the "Chromosome" assembly stage in November 2021:
for species in `grep -Pv '^Species\tAssembly\tSize' Teleostei_genomes_at_chromosome_assembly.tsv | awk -F '\t' '{print $1}' | sed 's| |+|g'` Lepisosteus+oculatus # File 'Teleostei_genomes_at_chromosome_assembly.tsv' was compiled using information on https://www.ncbi.nlm.nih.gov/genome/browse#!/overview/ on November 24, 2021.
do wget -O path1_$species https://www.ncbi.nlm.nih.gov/genome/?term=$species[orgn]
   sleep 1
   species_display=`echo $species | sed 's|+|_|g'`
   url=`grep 'Download sequences in FASTA format for' path1_$species | sed -e 's|">genome</a>.*||' -e 's|.*"||'`
   wget -O $species_display'_genomic.fna.gz' $url
done

# For the remaining 22 Teleostei genomes of interest:
wget -O Pundamilia_nyererei_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/239/375/GCF_000239375.1_PunNye1.0/GCF_000239375.1_PunNye1.0_genomic.fna.gz
wget -O Simochromis_diagramma_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/900/408/965/GCF_900408965.1_fSimDia1.1/GCF_900408965.1_fSimDia1.1_genomic.fna.gz
wget -O Mugil_cephalus_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/022/458/985/GCF_022458985.1_CIBA_Mcephalus_1.1/GCF_022458985.1_CIBA_Mcephalus_1.1_genomic.fna.gz
wget -O Poeciliopsis_prolifica_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/027/474/105/GCF_027474105.1_Auburn_PproV2/GCF_027474105.1_Auburn_PproV2_genomic.fna.gz
wget -O Synchiropus_splendidus_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/027/744/825/GCF_027744825.2_RoL_Sspl_1.0/GCF_027744825.2_RoL_Sspl_1.0_genomic.fna.gz
wget -O Acanthochromis_polyacanthus_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/021/347/895/GCF_021347895.1_KAUST_Apoly_ChrSc/GCF_021347895.1_KAUST_Apoly_ChrSc_genomic.fna.gz
wget -O Dicentrarchus_labrax_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/905/237/075/GCF_905237075.1_dlabrax2021/GCF_905237075.1_dlabrax2021_genomic.fna.gz
wget -O Micropterus_dolomieu_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/021/292/245/GCF_021292245.1_ASM2129224v1/GCF_021292245.1_ASM2129224v1_genomic.fna.gz
wget -O Labrus_bergylta_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/900/080/235/GCF_900080235.1_BallGen_V1/GCF_900080235.1_BallGen_V1_genomic.fna.gz
wget -O Gymnodraco_acuticeps_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/902/827/175/GCF_902827175.1_fGymAcu1.1/GCF_902827175.1_fGymAcu1.1_genomic.fna.gz
wget -O Pleuronectes_platessa_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/947/347/685/GCF_947347685.1_fPlePla1.1/GCF_947347685.1_fPlePla1.1_genomic.fna.gz
wget -O Anoplopoma_fimbria_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/027/596/085/GCF_027596085.1_Afim_UVic_2022/GCF_027596085.1_Afim_UVic_2022_genomic.fna.gz
wget -O Scomber_japonicus_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/027/409/825/GCF_027409825.1_fScoJap1.pri/GCF_027409825.1_fScoJap1.pri_genomic.fna.gz
wget -O Hippocampus_zosterae_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/025/434/085/GCF_025434085.1_ASM2543408v3/GCF_025434085.1_ASM2543408v3_genomic.fna.gz
wget -O Syngnathus_scovelli_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/024/217/435/GCF_024217435.1_RoL_Ssco_1.1/GCF_024217435.1_RoL_Ssco_1.1_genomic.fna.gz
wget -O Dunckerocampus_dactyliophorus_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/027/744/805/GCF_027744805.1_RoL_Ddac_1.1/GCF_027744805.1_RoL_Ddac_1.1_genomic.fna.gz
wget -O Ictalurus_furcatus_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/023/375/685/GCF_023375685.1_Billie_1.0/GCF_023375685.1_Billie_1.0_genomic.fna.gz
wget -O Clarias_gariepinus_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/024/256/425/GCF_024256425.1_CGAR_prim_01v2/GCF_024256425.1_CGAR_prim_01v2_genomic.fna.gz
wget -O Colossoma_macropomum_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/904/425/465/GCF_904425465.1_Colossoma_macropomum/GCF_904425465.1_Colossoma_macropomum_genomic.fna.gz
wget -O Xyrauchen_texanus_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/025/860/055/GCF_025860055.1_RBS_HiC_50CHRs/GCF_025860055.1_RBS_HiC_50CHRs_genomic.fna.gz
wget -O Carassius_gibelio_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/023/724/105/GCF_023724105.1_carGib1.2-hapl.c/GCF_023724105.1_carGib1.2-hapl.c_genomic.fna.gz
wget -O Misgurnus_anguillicaudatus_genome.fa.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/027/580/225/GCF_027580225.1_HAU_Mang_1.0/GCF_027580225.1_HAU_Mang_1.0_genomic.fna.gz

# Moving all these genomes into a dedicated directory:
mkdir Genomes
mv *_genomic.fna.gz Genomes/
