#!/bin/bash
#SBATCH --mem 30G
#SBATCH --partition=jic-medium,nbi-medium
#SBATCH --time=0-07:00
#SBATCH --cpus-per-task=1
#SBATCH --output=/path/to/log/directory/%x_%A_%a.out
#SBATCH --array=0-99

################################################################################################
### Set user inputs
################################################################################################
### Path of directory containing the matrix parts created in step 01
in_dir="path/to/directory/containing/matrix/parts"

### Path to an empty directory to save the output shared kmer state matrix parts
### It should be empty so that at step 03 it *only* contains the outputs from this script
out_dir="desired/output/directory"


################################################################################################
### Set up this particular array task
################################################################################################

### Source Singularity container with base R
### Note that this is specific to the Norwich Bioscience Insitutes' cluster
source package 52366f6b-2d86-42ed-88bf-b58f7e364c1c
echo "R package loaded"

### Save the array task ID into a more concise variable
i=$SLURM_ARRAY_TASK_ID

### Create an array of all matrix parts
readarray -t file_list < <(ls $in_dir)

### Set the file for each SLURM array task
input_file="${in_dir}/${file_list[i]}"
echo "Input file set"

### Create the output directory if it does not already exist
mkdir -p $out_dir


################################################################################################
### Run the accompanying R script
################################################################################################

### Run R script, supplying file as an argument
echo "Running R script"
Rscript 02b_calc_shared_kmer_states_per_matrix_part.r $input_file $out_dir

echo
echo "Finished running R script"