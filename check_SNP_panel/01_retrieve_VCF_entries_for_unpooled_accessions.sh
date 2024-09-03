#!/bin/bash

################################################################################################
### Set user options
################################################################################################

### Set the path to and name of the "minimal markers" text file
### This should have been generated from a filtered and linkage pruned VCF file for the pooled accessions
min_markers="path/to/min_markers.txt"

### Set the path to and name of the VCF file for the unpooled accessions
### This should be unfiltered and not linkage pruned
### It should also not be gzipped
VCF="path/to/input.vcf"

### Set the desired output directory
out_dir="path/to/output/directory"


################################################################################################
### Run script
################################################################################################

### Change into user-selected output directory
cd $out_dir

### Add the header from the unpooled VCF to a new file that will contain the target SNPs
grep "#CHROM" $VCF > target_SNPs.vcf

### Declare an array to store minimal marker variant names
declare -a variant_names

### Read the minimal marker file line by line
while IFS=$'\t' read -r -a fields; do

  ### Append the second field of the current line to the array
  variant_names+=("${fields[1]}")

done < $min_markers


### Grep each minimal marker within the unpooled VCF file
### (Note the array slicing phrase ":1" which means the loop will start from the second element of the array)
### (This is so we avoid the header line of the minimal marker file)
for name in "${variant_names[@]:1}"; do
  
  ### Find target SNP in unpooled VCF file and append to target_SNPs file
  grep $name $VCF >> target_SNPs.vcf

done

wait