# MR_code
This is me trying to figure out how to use GWAS info. 
`all.R` has every single aspect of the code 
I am using the following files: `DIAGRAMv3.2012DEC17.txt` (exposure) and `meta_analysis_ukbb_summary_stats_finngen_R12_F5_ALZHDEMENT_meta_out.tsv` (outcome) 

## Step 1 - Find the most significant SNPs 
lines 1-40 
## Step 2 - Add the SE and the log(or) to the document from step1 
-new csv `significant_snps_modified.csv`
- we format those to include only the columns rsid, pval, chr, pos, pheno, beta, SE, effect_allele, eaf, units, gene, ncase, ncontrol, sample size, trait_id (ieu-a-25), z, info 
- lines 50 -57 
## Step 3 - Clumping 
- this is to remove snps that are way too close to each other
- then we save as a new csv `clumped_snps.csv` - only need rsid, pval and id 
- lines 59-76

## EDITING IN BETWEEN: We do a lot of editing of the csvs outside of R in excel and to do this: 
- we use `=VLOOKUP($A2(col,2,eaf,3)`
- we add a new sheet for eaf that contains just the eaf values and the rest of the data we pull from and align 
  - a2 is the column we are pasting to, 2 is the column we are pulling info from, eaf is the sheet that we have renamed next to our current sheet and 3 is 
- then we do control c + Paste Values to remove the formatting and so it doesnt mess up in R
- 

