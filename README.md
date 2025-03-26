# MR_code

This is my process for working with GWAS summary statistics and Mendelian Randomization (MR).  
The script `all.R` contains all the necessary code.  
Make sure you run each step individually as you dont want to overwrite any of the files you edited outside 

### **Files Used**
- **Exposure**: `DIAGRAMv3.2012DEC17.txt`
- **Outcome**: `meta_analysis_ukbb_summary_stats_finngen_R12_F5_ALZHDEMENT_meta_out.tsv`

## Step 1 - Find the most significant SNPs from my DIAGRAMv3
- 📌 **Lines 1-40 in `all.R`**  
- Applied a significance threshold of **1e-8** to filter SNPs.  
- Extracted the following columns:
  - `SNP`, `CHROMOSOME`, `POSITION`, `RISK_ALLELE`, `OTHER_ALLELE`, `P_VALUE`, `OR`, `OR_95L`, `OR_95U`, `N_CASES`, `N_CONTROLS`
- Calculated `log_or` and `SE` in R (**Lines 44-48**).  
- Saved as a `.csv` for manual editing.

## Step 2 - Add the SE and the log(or) to the document from step1 
📌 **Lines 50-57 in `all.R`**  
- Created `significant_snps_modified.csv` with the following columns:
  - `rsid`, `pval`, `chr`, `pos`, `pheno`, `beta`, `SE`, `effect_allele`, `eaf`, `units`, `gene`, `ncase`, `ncontrol`, `sample size`, `trait_id` (ieu-a-25), `z`, `info`
- Added:
  - `beta`(log(OR), `z`(empty), `info` (empty)
  - `trait = "diabetes"`
  - `samplesize = ncase + ncontrol`
- **Effect Allele Frequency (EAF)**:
  - Got the `eaf` from `exposure_data.xlsx` - which I sadly did not compute, but it was derived from `ALL.wgs.phase3_shapeit2_mvncall_integrated_v5c.20130502.sites.vcf.gz.csi`
- Standardized column names for further analysis.
  
## Step 3 - Clumping 
📌 **Lines 59-76 in `all.R`**  
- Performed LD-based clumping to remove SNPs that are too close together.  
- Created `clumped_snps.csv`, keeping only:
  - `rsid`, `pval`, and `id` which is in the R code

## Step 4 - Extracting SNPs from Finngenn (UKB) to make outcome (dementia)
📌 **Lines 80-89 in `all.R`**  
- Created a `.txt` file with just the name of the snps SNPs: `alex_snps.txt`  
- Use this to extract snp list for outcome from UKB, producing `final_outcome_Alex.csv`
- This produces `final_outcome_Alex.csv`

## Step 5 - The Exposure edited 
📌 **Lines 91-107 in `all.R`** 
- here we make a new sheet to include only these: `SNP`	`p-val`	`effect`	`SE`	`a1`	`a2`	`a1_freq` (the eaf)	`Units` (empty)	`Gene` (empty)	`n` (this was known - its the 69k that is stated on the paper as well)
- creates `outcome_data.csv`
- you just add another sheet next to final outcome with different bits to fill and use the different functions in excel
- the R code just renames the columns in the necessary way
  
## Step 6 - The Outcome edited 
📌 **Lines 108-124 in `all.R`** 
- Edited the `final_outcome.csv` to include only these: `SNP`	`p-val`	`effect`	`SE`	`a1`	`a2`	`a1_freq` (the eaf)	`Units`	`Gene`	`n` (this was just found on google/given to me)
- Only use the UKB sections - can do Finngen later
- the R code just renames the columns in the necessary way 

## Harmonising 
📌 **Lines 126-130 in `all.R`** 
- This is just running the MR package to make something to use in the actual MR
- Then run various MR on the `UKB_harmonise.csv` - name is wrong cos

## EDITING IN BETWEEN: We do a lot of editing of the CSVs outside of R in excel and to do this: 
- i can't remember exactly where we edited stuff, i.e., the below was for the `eaf` which was given to me

### **Editing CSVs in Excel**
1. **Prepare the EAF Data**: 
- Create a new sheet that contains just the eaf values and the rest of the data we pull from and align next to our opened one (from step 2) which we name the table for `eaf` by clicking the right corner, highlighting and naming it2.
2. **Use `VLOOKUP` to Pull EAF Data**:  
- we use 
   ```excel
  =VLOOKUP($A2, eaf, 3, FALSE)
    ```
where: 
1. `$A2` is the value to look for.
2. `eaf` is the table range where it searches - to make this we select the entire table and rename it in the top right corner 
3. `3` means it returns the value from the third column of eaf.
4. `FALSE` ensures an exact match.
- `a2` is the column we are pasting to, `eaf` is the sheet that we have renamed next to our current sheet, and `3` is the column we are pulling info from
- then we do `control c` + `Paste Values` to remove the formatting and so it doesn't mess up in R

#### ALSO: the capitalisation of letters etc. is imperative and we need to change it manually in between sheets 

