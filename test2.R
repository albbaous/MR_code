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
