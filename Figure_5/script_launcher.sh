#!/bin/bash



#My arguments
gene_name=$1



#My variables
new_directory=$gene_name"_candidates_combined_orthologous"
candidate_checked=0
orthologous_check=0



#My conditions
if [[ $# -eq 0 ]] ; then
	echo 'Enter at least 1 argument (a valid gene name).'
    exit 0
fi

DIR=candidates/candidates_$gene_name/
if [[ -d "$DIR" ]];
then
    echo "$DIR  this directory exists."
    echo ""
    candidate_checked=1
    DIR2=orthologous/orthologous_$gene_name/
    if [[ -d "$DIR2" ]]; then
        echo "$DIR2     this directory exists."
        echo ""
        orthologous_checked=1
    else 
        echo "$DIR2 directory does not exist."
    fi    
else
	echo "$DIR directory does not exist."
fi




#My main program

if [[ $candidate_checked -eq 1 ]] && [[ $orthologous_checked -eq 1 ]] ; then
    #this python script groups ortholog of target site and miRNA sequence in a single file per species (and groups all these species-specific files in a decidated directory) 
    for file in candidates/candidates_$gene_name/*; do
        p=$file
        file_name=$( echo ${p##*/} )
        #echo $file_name
        python3 scripts/script_pair_candidate_and_orthologous.py $file orthologous/orthologous_$gene_name/Orthologous_"$gene_name"_sites.fa  

    done
    
    #this bash script runs an RNAduplex folding prediction for each file, therefore generating one predicted duplex per species
    cp scripts/script_Aligner_RNAduplex.sh $new_directory/.
    mkdir $new_directory/RNAduplex_aligned
    ./"$new_directory"/script_Aligner_RNAduplex.sh $new_directory


    #Copying necessary files to generate the newick and heatmap outputs
    cp scripts/merge.py $new_directory/RNAduplex_aligned/.    
    cp scripts/script_finalHeatmap.py $new_directory/RNAduplex_aligned/.
    cp scripts/script_newick_creator.py $new_directory/RNAduplex_aligned/.
    cp scripts/script_pre-treatment.py $new_directory/RNAduplex_aligned/.
    cp scripts/script_trait.py $new_directory/RNAduplex_aligned/.

    #This script outputs a 'merged_RNAduplex' file where each line is formatted as: SPECIE-NAME    PREDICTION-RNAduplex. That file will be used to generate both the newick and heatmap files.
    echo "Starting python3 merge.py "
    python3 $new_directory/RNAduplex_aligned/merge.py $new_directory/RNAduplex_aligned/
    echo "Finished python3 merge.py "
    mv "unfiltered_merged_RNAduplex" $new_directory/RNAduplex_aligned/
    
    echo "Starting python3 script_newick_creator.py "
    python3 $new_directory/RNAduplex_aligned/script_newick_creator.py Genomicus_tree_filtered.nwk $new_directory/RNAduplex_aligned/unfiltered_merged_RNAduplex
    echo "Finished python3 script_newick_creator.py "
    mv small_cladogram.newick $gene_name"_small_cladogram.newick"

    echo "Starting python3 script_trait.py"
    python3 $new_directory/RNAduplex_aligned/script_pre-treatment.py $new_directory/RNAduplex_aligned/unfiltered_merged_RNAduplex
    echo "Finished python3 script_trait.py "
    echo "Starting python3 script_pre-treatment.py  "
    python3 $new_directory/RNAduplex_aligned/script_trait.py $new_directory/RNAduplex_aligned/unfiltered_merged_RNAduplex
    mv merged_RNAduplex $new_directory/RNAduplex_aligned/.
    python3 $new_directory/RNAduplex_aligned/script_pre-treatment.py $new_directory/RNAduplex_aligned/merged_RNAduplex
    echo "Finished python3 script_pre-treatment.py  "
    echo ""

    echo "A newick file has been created in the current directory and it will be used to generate cladograms. Modify it by reordering its rows if necessary."
    echo ""
    echo "You can now run the 'script_Dataframe_treatment.sh' script to generate heatmaps."
fi
