Script and data files used to generate Figure 3D.

``R CMD BATCH R_commands_wt_variability_vs_inter-genotype_variability``

Output files:
* CSV files describing inter-wt fluctuations, as well as wt-to-mutant differences in gene expression (files named 'Inter\_vs\_intra\_genotype\_variability\_stage\_\*');
* PDF files containing graphs displaying gene expression values in both genotypes, for the genes where minimal inter-group variability exceeds maximal intra-WT-group variability (files named 'Extreme\_candidate\_in\_\*'). 
