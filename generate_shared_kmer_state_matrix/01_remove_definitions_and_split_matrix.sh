#!/bin/bash

################################################################################################
### Set user options
################################################################################################

### Set directory containing the final kmer matrix from the kmer-GWAS pipeline from Gaurav et al. 2022
in_dir=/path/to/directory/with/matrix

### Set name of kmer matrix
matrix_name=name_of_matrix.txt

### Number of parts to split the matrix into. I used 100 for my project (~500 M kmers listed for 220 accessions).
### Consider splitting less or more based on the size of your initial kmer matrix.
num_parts=100


################################################################################################
### Run script
################################################################################################

### Cut function retains only the second column of the input kmer matrix.
### We don't need the first column as this contains the kmer 'definitions' (the sequences)
### which we are not interested in here
cut -f 2 $in_dir/$matrix_name > $in_dir/kmer_matrix_definitions_removed.txt

### Define and create an output directory for the matrix parts
parts_dir=$in_dir/matrix_parts_${num_parts}
mkdir -p $parts_dir

### Split the kmer matrix into the desired number of parts
split --number=l/$num_parts $in_dir/kmer_matrix_definitions_removed.txt $parts_dir/kmer_matrix_definitions_removed_
