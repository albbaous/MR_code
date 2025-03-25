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
significant_snps <- data[data$P_VALUE < 1e-8, ]

# Check the filtered data
head(significant_snps)

# Optionally, save the filtered data to a new file
write.table(significant_snps, file = "/Users/user/Desktop/Biostatistics1/testing_mr/most_significant_snps.txt", row.names = FALSE, quote = FALSE, sep = "\t")

# Print a message when done
cat("The most significant SNPs have been saved to 'most_significant_snps.txt'.\n")
###### generate the SE and log oras an additional column to these 
# Assuming significant_snps is your existing dataset

significant_snps <- significant_snps %>%
  mutate(
    log_OR = log(OR),  # Calculate log(OR)
    SE = (log(OR_95U) - log(OR_95L)) / (2 * 1.96)  # Calculate SE based on confidence intervals
  )

# make it into a csv 
# Define the output file path
output_file <- "significant_snps_modified.csv"

# Write the updated dataframe to CSV
write.csv(significant_snps, file = output_file, row.names = FALSE)

cat("CSV file has been saved to", output_file, "\n")
##########
library(dplyr)
library(TwoSampleMR)
clumpdata <- read.csv("/Users/user/Desktop/Biostatistics1/testing_MR/snps_for_clumping.csv")

plink_path <- "/Users/user/Desktop/Biostatistics1/testing_MR/plink_mac_20241022/plink"  # Update this with the actual path
# Run clumping
clump_results <- ld_clump(
  dplyr::tibble(rsid = clumpdata$rsid, pval = clumpdata$pval, id = clumpdata$trait_id),
  plink_bin = plink_path,
  bfile = "/Users/user/Desktop/Biostatistics1/testing_MR/1kg.v3/EUR" 
)

# make it into a csv 
# Define the output file path
output2_file <- "clumped_snps.csv"

# Write the updated dataframe to CSV
write.csv(clump_results, file = output2_file, row.names = FALSE)

## extracting snps from finngenn 
#command to extract snp list for snps exposure (after clumping) in finngen database
library(data.table)
snp_list <- fread("alex_snps.txt", header = FALSE)$V1
# Load large TSV file (only if memory allows)
file_path <- "/Users/user/Desktop/Biostatistics1/testing_MR/meta_analysis_ukbb_summary_stats_finngen_R12_F5_ALZHDEMENT_meta_out.tsv"
data <- fread(file_path, sep = "\t")
# Filter for SNPs of interest
filtered_data <- data[rsid %in% snp_list]

# Save output
fwrite(filtered_data, "final_outcome_Alex.csv", sep = ",")

# read outcome_data.csv back in after editing it in excel 
#read the diabetes exposure
exposure_file <- "exposure_data.csv"
exposure_dat <- read_exposure_data(
  filename = exposure_file,
  sep = ",",
  snp_col = "SNP",
  beta_col = "effect",
  se_col = "SE",
  effect_allele_col = "a1",
  other_allele_col = "a2",
  eaf_col = "a1_freq",
  pval_col = "p-val",
  units_col = "Units",
  gene_col = "Gene",
  samplesize_col = "n"
)

#read the diabetes exposure
outcome_file <- "outcome_data.csv"
outcome_dat <- read_outcome_data(
  filename = outcome_file,
  sep = ",",
  snp_col = "SNP",
  beta_col = "effect",
  se_col = "SE",
  effect_allele_col = "a1",
  other_allele_col = "a2",
  eaf_col = "a1_freq",
  pval_col = "p-val",
  units_col = "Units",
  gene_col = "Gene",
  samplesize_col = "n"
)

#harmonising
UKB_H_dat <- harmonise_data(
  exposure_dat = exposure_dat,
  outcome_dat = outcome_dat
)
write.csv(UKB_H_dat, "UKB_harmonise.csv", row.names = FALSE)

#running mr
mr_UKB_H <- mr(UKB_H_dat)
mr_UKB_H
#add OR
mr_UKB_H$OR <- exp(mr_UKB_H$b)
print(mr_UKB_H)

library(dplyr)
UKB_H_dat <- UKB_H_dat %>% filter(mr_keep != "FALSE")

#Add 95%CI
mr_UKB_H$lower_CI <- exp(mr_UKB_H$b - 1.96 * mr_UKB_H$se)
mr_UKB_H$upper_CI <- exp(mr_UKB_H$b + 1.96 * mr_UKB_H$se)
print(mr_UKB_H)

write.csv(mr_UKB_H, "UKB_MR.csv", row.names = FALSE)

####get the plot
install.packages("tidyverse")
install.packages("gridExtra")
library(ggplot2)
library(gridExtra)
library(TwoSampleMR)
forest_plot <- ggplot(mr_UKB_H, aes(x = OR, y = method)) +
  geom_point() +  # Add the ORs as points
  geom_errorbarh(aes(xmin = lower_CI, xmax = upper_CI), height = 0.2) +  # Add horizontal error bars for 95% CI
  theme_minimal() +
  labs(x = "Odds Ratio", y = "Method", title = "Forest Plot of Odds Ratios")
print(forest_plot)
data_table <- gridExtra::tableGrob(mr_UKB_H)
gridExtra::grid.arrange(data_table, forest_plot, ncol = 2)
#Horizontal pleiotropy-using harmonised data UKB_H_dat
mr_pleiotropy_test(UKB_H_dat)
#Heterogeneity statistics
mr_heterogeneity(UKB_H_dat)

#limit method in heterogeneity
mr_heterogeneity(UKB_H_dat, method_list = c("mr_weighted_median", "mr_ivw"))
mr_UKB <- mr(UKB_H_dat)
#Scatter plot
MR_all_scatter <- mr_scatter_plot(mr_UKB_H, UKB_H_dat)
MR_all_scatter [[1]]

#looking at single SNP
res_single <- mr_singlesnp(UKB_H_dat)
#he method used to perform the single SNP MR is the Wald ratio by default
res_single <- mr_singlesnp(UKB_H_dat, single_method = "mr_meta_fixed")
#the full MR using all available SNPs as well, and by default it uses the IVW and MR Egger methods
res_single <- mr_singlesnp(UKB_H_dat, all_method = "mr_two_sample_ml")
#PLOT
res_single <- mr_singlesnp(UKB_H_dat)
p2 <- mr_forest_plot(res_single)
p2[[1]]
#PLOT USE DIFFERENT METHOID
res_single <- mr_singlesnp(UKB_H_dat, all_method = c("mr_ivw", "mr_two_sample_ml"))
p3 <- mr_forest_plot(res_single)
p3[[1]]

#Funnel plot
res_single <- mr_singlesnp(UKB_H_dat)
p4 <- mr_funnel_plot(res_single)
p4[[1]]
#leave one-out analysis and plot
#PLOT LOO
res_loo <- mr_leaveoneout(UKB_H_dat)
p5 <- mr_leaveoneout_plot(res_loo)
p5[[1]]

#Install MR-Presso
devtools::install_github("rondolab/MR-PRESSO",force = TRUE)
library(MRPRESSO)
# Run MR-PRESSO global method using Harmonised data UKB_H_dat
mrpresso_result_UKB<-mr_presso(BetaOutcome = "beta.outcome", BetaExposure = "beta.exposure", SdOutcome = "se.outcome", SdExposure = "se.exposure", OUTLIERtest = TRUE, DISTORTIONtest = TRUE, data = UKB_H_dat, NbDistribution = 1000,  SignifThreshold = 0.05)
mrpresso_result_UKB
tt1_mrpresso_result_UKB <- mrpresso_result_UKB[[1]]

# Convert causal estimates to odds ratios
tt1_mrpresso_result_UKB$OR <- exp(tt1_mrpresso_result_UKB$`Causal Estimate`)

# Convert confidence intervals to odds ratios
tt1_mrpresso_result_UKB$lower_CI <- exp(tt1_mrpresso_result_UKB$`Causal Estimate` - 1.96 * tt1_mrpresso_result_UKB$Sd)
tt1_mrpresso_result_UKB$upper_CI <- exp(tt1_mrpresso_result_UKB$`Causal Estimate` + 1.96 * tt1_mrpresso_result_UKB$Sd)

# Round the results for readability
tt1_mrpresso_result_UKB$OR <- round(tt1_mrpresso_result_UKB$OR, 4)
tt1_mrpresso_result_UKB$lower_CI <- round(tt1_mrpresso_result_UKB$lower_CI, 4)
tt1_mrpresso_result_UKB$upper_CI <- round(tt1_mrpresso_result_UKB$upper_CI, 4)


print(tt1_mrpresso_result_UKB)

write.csv(tt1_mrpresso_result_UKB, "I:/passport drive_01_12_2015/Mandelian randomisation/Cadmium/tt1_mrpresso_result_UKB.csv", row.names = FALSE)

#CHECK PROBLEMATIC SNPS IN PRESSO
problematic_snps <- tt1_mrpresso_result_UKB[tt1_mrpresso_result_UKB$Outlier == "Yes", "SNP"]
print(problematic_snps)

#use this command for MR strieger to report r2 and p-value
out <- directionality_test(UKB_H_dat)
knitr::kable(out)

#check F statistics
# Calculate F-statistic per SNP
UKB_H_dat$F_statistic <- (UKB_H_dat$beta.exposure^2) / (UKB_H_dat$se.exposure^2)

# Print summary of F-statistics
summary(UKB_H_dat$F_statistic)

# Check how many SNPs are weak (F < 10)
sum(UKB_H_dat$F_statistic < 10)
write.csv(UKB_H_dat, "MR_SNP_F_Statistics.csv", row.names = FALSE)

