library(tidyverse)

################################################################################################
### Set user options
################################################################################################

### Set directory containing the "target_SNPs.vcf" file from step 01
target_SNPs_dir="/directory/containing/target/SNPs/file"

### Set the path to and name of the accession pools file
pools_path="/path/to/accession_pools.txt"


################################################################################################
### Load in and prep "target_SNPs.vcf" file
################################################################################################

target_SNPs <- read.table(paste0(target_SNPs_dir, "/target_SNPs.vcf"), comment.char = "", header=TRUE)

colnames(target_SNPs)[1] <- "CHROM"

dim(target_SNPs)
head(target_SNPs)

### Remove unneeded columns
target_SNPs_clean <- target_SNPs[,c(-1,-2,-4,-5,-6,-7,-8,-9)]

### Want to remove most of the junk from the VCF entries - keep only the genotype call, i.e. what comes before the colon
### Function to extract the first field before the colon
extract_first_field <- function(x) {
  sapply(strsplit(x, ":"), `[`, 1)
}

### Apply the function to each element of the data frame
target_SNPs_clean <- as.data.frame(apply(target_SNPs_clean, 2, extract_first_field), stringsAsFactors = FALSE)

dim(target_SNPs_clean)
head(target_SNPs_clean)


################################################################################################
### Check distribution of markers
################################################################################################
table(target_SNPs$CHROM)


################################################################################################
### Check number of heterozygous cells
################################################################################################

### Convert the dataframe to a matrix and then to a vector
all_values <- as.vector(as.matrix(target_SNPs_clean))

### Count the occurrences of the search string
count <- sum(all_values == "0/1")

count


################################################################################################
### Read in accession pools
################################################################################################

pools <- read.table(pools_path, header=TRUE, sep="\t")
View(pools)


################################################################################################
### Create subsets of the "target_SNPs_clean" dataframe for each pool
################################################################################################

subsets <- list()

for (i in 1:ncol(pools)){
  
  accessions <- (pools[,i])
  
  accessions <- accessions[nzchar(accessions)]
  
  temp_df <- target_SNPs_clean %>% subset(select = accessions)
  
  subsets[[i]] <- temp_df
  
}


###############################################################
### Examine the pools for differences amongst the markers
###############################################################

subsets


################################################################################################
### Explicitly list all cases where there are differences amongst pools (useful for large pools)
################################################################################################

### Function to check if all elements in a row are the same
all_same <- function(row) {
  length(unique(row)) != 1
}


for (i in 1:length(subsets)){
  
  diff_rows <- subsets[[i]][apply(subsets[[i]], 1, all_same), ]
  
  if (nrow(diff_rows) > 0){
    print(diff_rows)
  }
}


################################################################################################
### Check coverage at heterozygous sites
################################################################################################
### There will inevitably be some heterozygous calls for a few marker/accession combinations in the unpooled VCF.
### However, these may just be weak calls with few total reads supporting them (rather than true heterozygous loci).
### Below you can examine specific VCF entries by selecting desired combinations of markers and unpooled accessions.

### Reminder of VCF format:
# GT:PL:DP:SP:AD:GP:GQ
# GT = genotype
# PL = 
# DP = depth
# SP = 
# AD = 
# GP =
# GQ = genotype quality (higher is better)

### Examples:

### Teff_42 pool
strsplit(target_SNPs[1,"accession_1"], ":")

### Teff_71 pool
strsplit(target_SNPs[3,"accession_71"], ":")

### Teff_82 pool
strsplit(target_SNPs[9,"accession_63"], ":")

### accession_156 pool
strsplit(target_SNPs[3,"accession_156"], ":")