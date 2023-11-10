#!/bin/sh

if test "$1" = ""
then echo "Please enter input file name (fasta file with accession number as the first field in header lines; e.g., Tead3b_ortholog_transcripts.fa)."
     read file
else file=$1
fi

echo "Accession_number GI_number Start_of_3p_UTR" > 3p_UTR_starts_in_$file'.txt'
for acc in `grep '^>' $file | sed -e 's|^> *||' -e 's| .*||'`
do wget -O tmp1_$acc http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=nucleotide\&term=$acc
   sleep 1
   for ID in `grep -P '^\t*<Id>' tmp1_$acc | sed -e 's|^\t*<Id>||' -e 's|</Id>||'`
   do wget -O NCBI_sheet'_'$ID'_for_'$acc http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide\&id=$ID\&rettype=gb
      sleep 1
      end_CDS=`grep '^ *CDS ' NCBI_sheet'_'$ID'_for_'$acc | awk '{print $2}' | sed 's|.*\.\.||'`
      if test "$end_CDS" = ""
      then start_UTR=NA
      else start_UTR=`echo $end_CDS"+1" | bc`
      fi
      species=`grep '^SOURCE ' NCBI_sheet'_'$ID'_for_'$acc | sed -e 's|^SOURCE  *||' -e 's| (.*||' -e 's| |_|g'`
      echo $species $acc $ID $start_UTR
   done
done >> 3p_UTR_starts_in_$file'.txt'
