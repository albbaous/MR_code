library(remotes)
install.packages("remotes")
install.packages("devtools")
library(devtools)
library(remotes)
options(timeout = 300)  # Increase timeout to 5 minutes
devtools::install_github("explodecomputer/genetics.binaRies")
genetics.binaRies::get_plink_binary()
remotes::install_github("MRCIEU/TwoSampleMR")
install.packages("dplyr")  # For tibble and data manipulation
library(ieugwasr)
install.packages("data.table")
library(data.table)
library(dplyr)
library(TwoSampleMR)
setwd("/Users/user/Desktop/Biostatistics1/testing_MR")
getwd()

# Load necessary libraries
library(data.table)

# Path to your file
file_path <- "/Users/user/Desktop/Biostatistics1/testing_MR/DIAGRAMv3.2012DEC17.txt"

# Read the dataset (assuming it is tab-delimited; modify sep if necessary)
data <- fread(file_path)

# Check the first few rows of the dataset to understand its structure
head(data)

# Filter SNPs with p-value less than 5e-8 (assuming p-value column is named "P_VALUE" or similar)
# If the p-value column is named differently, adjust accordingly.
significant_snps <- data[data$P_VALUE < 5e-8, ]

# Check the filtered data
head(significant_snps)

# Optionally, save the filtered data to a new file
write.table(significant_snps, file = "/Users/user/Desktop/Biostatistics1/testing_mr/most_significant_snps.txt", row.names = FALSE, quote = FALSE, sep = "\t")

# Print a message when done
cat("The most significant SNPs have been saved to 'most_significant_snps.txt'.\n")
