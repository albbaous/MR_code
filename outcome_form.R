# Load required libraries
library(data.table)
library(dplyr)

# Define file paths
clumped_snps_path <- "clumped_snps.txt"  # Clumped SNPs list
outcome_path <- "meta_analysis_ukbb_summary_stats_finngen_R12_F5_ALZHDEMENT_meta_out.tsv"  # Outcome file
output_path <- "outcome_formatted.txt"  # Formatted output file

# Load clumped SNPs
clumped_snps <- fread(clumped_snps_path, header = FALSE)$V1  # Extract SNP IDs

# Load outcome data
outcome_data <- fread(outcome_path, sep = "\t", header = TRUE)

# Filter outcome data based on clumped SNPs
filtered_outcome <- outcome_data[outcome_data$rsid %in% clumped_snps]

# Select and rename only the required columns
outcome_dat <- filtered_outcome %>%
  select(
    SNP = rsid,                      # SNP ID
    beta = all_inv_var_meta_beta,     # Effect size
    se = all_inv_var_meta_sebeta,     # Standard error
    effect_allele = ALT,              # Effect allele
    other_allele = REF,               # Non-effect allele
    pval = all_inv_var_meta_p         # P-value
  )

# Save the formatted dataset
fwrite(outcome_dat, output_path, sep = "\t", row.names = FALSE, quote = FALSE)

# Verify structure
print(colnames(outcome_dat))
head(outcome_dat)

cat("Formatted outcome data saved to", output_path, "\n")

# Print a sample of both datasets - i am trynna figure out why my strands have come out funny ?? 
print(clumped_snps)
print(outcome_dat)
