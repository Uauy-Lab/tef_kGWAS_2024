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

## Calculating pairwise shared k-mer state rates
Calculates the fraction of k-mers that each pair of accessions has the same state for across all k-mers identified in the population.
Output is an n x n matrix, where n is the number of accessions in your population.

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
Output is an n x 2 matrix, where n is the number of accessions in your population. The two columns are accession name and number of k-mer presences.

**Requirements:**
- A UNIX shell such as BASH

**Input files:**
- A population k-mer matrix generated according to Gaurav et al., 2022
- A single-column text file listing all accessions, one per line

**Steps:**

Script 01) This script takes the k-mer matrix as input counts the number of "presences" (1's) for each accession

## Identifying potential SNP-panel discrepancies between accession pools and their constituent members

**Requirements:**
**Input files:**

