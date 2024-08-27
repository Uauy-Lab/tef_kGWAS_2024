#!/bin/bash

################################################################################################
### Set user options
################################################################################################

### Set directory containing the final kmer matrix from the kmer-GWAS pipeline from Gaurav et al. 2022
in_dir="path/to/input/directory"

### Set the name of the final kmer matrix
matrix="name_of_kmer_matrix.txt"

### Set desired output directory
out_dir="path/to/output/directory"

### Set the path and name of a single-column TSV file listing the accessions
accessions_file="path/to/accessions.txt"


################################################################################################
### Run script
################################################################################################

### Change into directory with kmer matrix
cd $in_dir
echo "Changed into input directory, starting to process kmer matrix..."

### Count the number of accessions and save in a variable
accession_count=$(wc -w < $accessions_file)

### Count the kmers for each accession (note we substitute in the number of accessions from our "accession_count" variable)
awk -v ac="$accession_count" '{for (i=1; i<=ac; i++) count[i]+=substr($0,i,1)} END {for (i=1; i<=ac; i++) print count[i]}' $matrix \
> $out_dir/kmer_presence_counts_raw.txt
echo "Counting finished!"


echo
echo "Pasting accession names and kmer counts files together..."
paste $accessions_file $out_dir/kmer_presence_counts_raw.txt > $out_dir/kmer_presence_counts_with_acc_names.txt
echo "Pasting finished, end of script"

wait

echo
echo "Deleting intermediate file"
rm $out_dir/kmer_presence_counts_raw.txt
echo "Finished deleting. End of script."