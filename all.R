# THIS ONLY WORKS WELL BECAUSE ALL INSTALLATION STEPS ARE AT THE START, SEPARATED FROM THE REST 
install.packages("remotes")
install.packages("devtools")
install.packages("data.table")
options(timeout = 300)  # Increase timeout to 5 minutes
devtools::install_github("explodecomputer/genetics.binaRies")
genetics.binaRies::get_plink_binary()
remotes::install_github("MRCIEU/TwoSampleMR")
install.packages("dplyr")  # For tibble and data manipulation
library(devtools)
library(remotes)
library(ieugwasr)
library(remotes)
library(data.table)
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
########################################################################################
# Load necessary library
library(dplyr)
library(TwoSampleMR)

# Define paths
plink_path <- "/Users/user/Desktop/Biostatistics1/testing_MR/plink_mac_20241022/plink"
bfile_path <- "/Users/user/Desktop/Biostatistics1/testing_MR/1kg.v3/EUR"  # 1000 Genomes reference panel (EUR)
sumstats_path <- "/Users/user/Desktop/Biostatistics1/testing_MR/most_significant_snps.txt"  # Your summary statistics file
output_path <- "/Users/user/Desktop/Biostatistics1/testing_MR"  # Output directory

# Read summary statistics
dat <- read.table(sumstats_path, header = TRUE, stringsAsFactors = FALSE)
# Prepare data for clumping: Ensure correct column names for PLINK and calculate SE
clump_input <- dat %>%
  select(SNP, CHROMOSOME, POSITION, RISK_ALLELE, OTHER_ALLELE, P_VALUE, OR, N_CASES, N_CONTROLS) %>%
  rename(
    rsid = SNP,                        # Rename SNP column to rsid for compatibility with ld_clump
    effect_allele.exposure = RISK_ALLELE, # Effect allele for exposure
    other_allele.exposure = OTHER_ALLELE, # Other allele for exposure
    pval = P_VALUE                         # Rename P_VALUE to P for PLINK compatibility
  ) %>%
  mutate(
    id.exposure = rsid,                  # Unique identifier for the exposure (using rsid)
    exposure = "diabetes",               # Name of the exposure (can modify as necessary)
    beta.exposure = log(OR),             # Log of OR for beta.exposure
    Z_score = qnorm(1 - as.numeric(pval) / 2),          # Calculate the Z-score from the p-value
    se.exposure = beta.exposure / Z_score, # Standard error calculation
    pval = as.numeric(pval)
  )

# Save the clump_input as a tab-separated text file (making sure to remove row names and quoting values)
write.table(clump_input, file = "clump_input_for_plink.txt", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")

# Run PLINK LD Clumping (ensure clumping is only done on relevant SNPs)
clumped_snps <- ld_clump(
  clump_input,             # Data frame prepared for PLINK LD clumping
  plink_bin = plink_path,  # Path to the PLINK binary
  bfile = bfile_path       # Path to the reference panel (PLINK binary files)
)

# Check the results of LD clumping
head(clumped_snps)

