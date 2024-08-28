library(tidyverse)

################################################################################################
### Set user options
################################################################################################

### Set input directories and files.
### For the directories it does not matter if you end on a backslash or not.

### Set the directory containing the shared kmer state matrix parts from step 02
### These matrix parts should be the *only* files in this directory for this script to work correctly
parts_dir <- "/path/to/matrix/parts/dir"

### Set the path and name of a single-column text file listing the accessions
### Length must be the same as the number of columns and number of rows of the input matrices
accessions_file <- "/path/to/accessions/file.txt"

### Set a directory to output the final shared kmer state rate matrix to
out_dir <- "/path/to/output/directory"


################################################################################################
### Load in data
################################################################################################

### Create a vector listing paths and names of all shared kmer state matrix parts
matrix_part_paths <- fs::dir_ls(parts_dir)

### Remove element names from the vector of file paths
matrix_part_paths <- unname(matrix_part_paths)

### Create an empty list to store the contents of these files
matrix_part_contents <- list()

### Load the data into the above list
for (i in seq_along(matrix_part_paths)) {
    matrix_part_contents[[i]] <- read.table(file = matrix_part_paths[i], sep=' ', header=FALSE)
}

### Check the last part for appearance and dimensions
dim(matrix_part_contents[[i]])
head(matrix_part_contents[[i]])


################################################################################################
### Sum the matrix parts together
################################################################################################

summed_parts <- Reduce(`+`, lapply(matrix_part_contents, as.matrix))

dim(summed_parts)
head(summed_parts)


################################################################################################
### Add accession names back in
################################################################################################

### Load names from single-column TSV into a dataframe
names <- read.table(accessions_file, header=FALSE)

### Rename the only column
colnames(names) <- "code"
head(names, n=3)

### Set rownames and column names for the final identity matrix
colnames(summed_parts) <- names$code
rownames(summed_parts) <- names$code

head(summed_parts)

################################################################################################
### Convert from absolute numbers of shared kmer states to fractions
################################################################################################

### Divide all cells by the total number of kmers tested
### Note that this is given by the [1,1] coordinate or any cell on the main diagonal.
### This is because any accession must be completely identical to itself so will
### share the same kmer state for 100% of the kmers
summed_parts_frac <- summed_parts / summed_parts[1,1]

### Set precision of table before exporting
options(digits = 3)

### Final check of table
head(summed_parts_frac)


################################################################################################
### Export
################################################################################################

### Export table
write.csv(summed_parts_frac, paste0(out_dir,"/shared_kmer_state_rates.csv"))
