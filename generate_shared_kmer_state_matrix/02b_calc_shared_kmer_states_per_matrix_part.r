### Read arguments from the command that started the R session
args <- commandArgs()
### Take the sixth argument (this should be the file name passed in my bash script)
file_name <- args[6]

### Set the output directory based on the seventh argument passed to the R script
out_dir  <- args[7]

### Read in the specified file as a dataframe (without a header as data begins at row 1)
kmer_matrix <- read.table(file_name, header=FALSE)
print("kmer matrix part read in successfully")

### Print the dimensions of the kmer matrix. Set a variable recording the number of columns. 
dim(kmer_matrix)
num_acc <- ncol(kmer_matrix)


###########################################################################################
### Define an empty count matrix (num accessions x num accessions)
###########################################################################################

count_matrix = data.frame(matrix(nrow = num_acc, ncol = num_acc))

print("")
print("Empty count matrix created")


###########################################################################################
### Calculate the shared kmer states for this matrix part
###########################################################################################

print("")
print("Calculating number of shared kmer states")

for (i in 1:num_acc) {
    for (j in 1:num_acc) {
        
        count_matrix[i,j] <- length(which(kmer_matrix[,i] == kmer_matrix[,j]))
        
    }
}

print("Finished creating this shared kmer state matrix part")


###########################################################################################
### Export the created matrix part
###########################################################################################

### Pull out the prefix of the input kmer matrix part to use for naming the output file

### This is a base R method to achieve what "str_split_i" from tidyverse does
split_file_name <- strsplit(file_name, "_", fixed = TRUE)
file_prefix <- tail(split_file_name[[1]], n=1)
### Note that strsplit produces a list of vectors, so need to call the first list element
### (the only element in this case) using [[]] notation


### Write the output table
write.table(count_matrix, paste0(out_dir,"/shared_kmer_states", file_prefix),
            row.names=FALSE, col.names=FALSE)

print("Export of this shared kmer state matrix part is complete")