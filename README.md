# Code for tef kmer GWAS project

This repository contains the code used for analyses in the paper "" that were not performed using standard or already-published bioinformatics tools.

Three functionalities are provided:
- Calculating pairwise shared k-mer state rates
- Calculating the total number of k-mers presences per accession (i.e. 1's in the k-mer matrix)
- Identifying potential discrepancies between accession pools and their constituent members for a SNP-panel

Notes:
- "Accession" can be replaced by your desired genotypic unit, e.g. individual, sub-species, species, genera
- "Population" is used here to mean the complete set of accessions (or equivalent) studied in your project
- Example files are provided in the "example_files" folder
- Full references for citations are provided at the end of this document

## Calculating pairwise shared k-mer state rates
Calculates the fraction of k-mers that each pair of accessions has the same state for across all k-mers identified in the population. The output is an n x n matrix, where n is the number of accessions in your population.

**Requirements:**
- A UNIX shell such as BASH
- R with Tidyverse
- A method to submit many R scripts in parallel (e.g. via submission to a computing cluster)

**Input files:**
- A population k-mer matrix generated according to Gaurav et al., 2022
- A single-column text file listing all accessions, one per line

**Steps:**

Script 01) This script splits the input k-mer matrix into the specified number of parts. It splits whole lines only so will not generate aberrant entries.

Script 02a) An example BASH script to submit many instances of the R script "02b_calc_shared_kmer_states_per_matrix_part.r". Designed to run on the "slurm" job allocation system used by the Norwich Bioscience Institutes computing cluster.

Script 02b) This script takes one k-mer matrix part as input and calculates the number of k-mers each pair of accessions have the same state for, state being "present" (1) or "absent" (0).

Script 03) This script sums the matrices output by all instances of script 02b then divides by the total number of k-mers to create a final matrix recording the shared k-mer state rate between all pairs of accessions.

## Calculating the total number of k-mer presences per accession
Calculates the number of unique k-mers found within the sequencing reads of each accession. i.e. how many 1's does each accession have in the k-mer matrix?
The output is an n x 2 matrix, where n is the number of accessions in your population. The two columns are accession name and number of k-mer presences.

**Requirements:**
- A UNIX shell such as BASH

**Input files:**
- A population k-mer matrix generated according to Gaurav et al., 2022
- A single-column text file listing all accessions, one per line

**Steps:**

Script 01) This script takes the k-mer matrix as input counts the number of "presences" (1's) for each accession

## Identifying potential SNP-panel discrepancies between accession pools and their constituent members
We generated a minimal SNP set that uniquely identifies the accessions and accession pools in our study. These two scripts were used check whether the constituent accessions grouped into the pools always had the same alleles for these SNPs as the pools themselves.

**Requirements:**
- A UNIX shell such as BASH
- R with Tidyverse

**Input files:**
- A "minimal markers" text file generated according to Winfield et al., 2020. Use the version without the header of accessions names (see example files). To generate the minimal markers text file, use the VCF file for the pooled accessions. This VCF file should be quality-filtered and linkage-pruned.
- A VCF file for the unpooled accessions. This should not be quality-filtered or linkage-pruned to ensure the SNPs selected by the minimal markers pipeline are not removed. The third column should contain "variant names" and these must be of the same format as in the VCF file for the pooled accessions (e.g. chromsome_coordinate; 4B_45006711)
- A file describing the accession pools as per the example file "example_accession_pools.txt"

**Steps:**

Script 01) This script extracts the variant names of the SNPs selected by the minimal markers pipeline, then pulls the entries for these SNPs from the VCF for the unpooled accessions. The output is a very short VCF file named "target_SNPs.vcf", with only the selected SNPs

Script 02) This script loads the short VCF file of target SNPs into R, along with a metadata file describing the accession pools. The inputs are then formatted to allow easy visual examination of the alleles called for each of the pool constituents. This should be compared vs the original minimal markers output to see if the constituents agree with their pool. Other statistics are also calculated, such as number of markers per chromosome.

## References
- Gaurav, K., Arora, S., Silva, P. *et al.* Population genomic analysis of *Aegilops tauschii* identifies targets for bread wheat improvement. *Nat Biotechnol* 40, 422–431 (2022). https://doi.org/10.1038/s41587-021-01058-4
- Winfield M, Burridge A, Ordidge M, Harper H, Wilkinson P, Thorogood D, et al. (2020) Development of a minimal KASP marker panel for distinguishing genotypes in apple collections. PLoS ONE 15(11): e0242940. https://doi.org/10.1371/journal.pone.0242940
