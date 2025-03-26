# MR_code
This is me trying to figure out how to use GWAS info. 
`all.R` has every single aspect of the code 
I am using the following files: `DIAGRAMv3.2012DEC17.txt` (exposure) and `meta_analysis_ukbb_summary_stats_finngen_R12_F5_ALZHDEMENT_meta_out.tsv` (outcome) 

## Step 1 - Find the most significant SNPs from my DIAGRAMv3
- lines 1-40
- used a signficance of 1e-8
- these are the columns it produced: `SNP`	`CHROMOSOME`	`POSITION`	`RISK_ALLELE`	`OTHER_ALLELE`	P_VALUE	OR	OR_95L	OR_95U	N_CASES	N_CONTROLS
- generated 'log_or' and 'SE' in R (refer to the code 44-48)
- wrote into a .csv to edit myself 

## Step 2 - Add the SE and the log(or) to the document from step1 
- new csv `significant_snps_modified.csv`
- format those to include only the columns `rsid`, `pval`, `chr`, `pos`, `pheno`, `beta`, `SE`, `effect_allele`, `eaf`, `units`, `gene`, `ncase`, `ncontrol`, `sample size`, `trait_id` (ieu-a-25), `z`, `info` to then produce the `snps_for_clumping.csv`
-  things to add were just the `beta`, `z`, `info` (empty), `trait` (diabetes), `samplesize` (which was just adding `ncontrol` and `ncase`)
-  we got the `eaf` from `exposure_data.xlsx` - which I sadly did not compute, but it was derived from `ALL.wgs.phase3_shapeit2_mvncall_integrated_v5c.20130502.sites.vcf.gz.csi`
-  the rest was just a case of renaming 
- lines 50 -57
  
## Step 3 - Clumping 
- this is to remove snps that are way too close to each other
- then we save as a new csv `clumped_snps.csv` - only need `rsid`, `pval` and `id` which is specified in the R code 
- lines 59-76

## Step 4 - Extracting SNPs from Finngenn to make outcome (dementia)
- make a `.txt` file with just the names of your snps called `alex_snps.txt`
- then use this to extract snp list for the outcome in Finngen database
- this produces `final_outcome_Alex.csv`
- lines 80-89

## Step 5 - The Outcome edited 
- here we edit the `final_outcome.csv` to include only these: `SNP`	`p-val`	`effect`	`SE`	`a1`	`a2`	`a1_freq` (the eaf)	`Units`	`Gene`	`n` (this was just found on google/given to me)
- we use only the Finngen sections - can do UKB later
- the R code just renames the columns in the necessary way 

## Step 6 - The Exposure edited 
- here we make a new sheet to include only these: `SNP`	`p-val`	`effect`	`SE`	`a1`	`a2`	`a1_freq` (the eaf)	`Units` (empty)	`Gene` (empty)	`n` (this was known - its the 69k that is stated on the paper as well)
- creates `outcome_data.csv`
- you just add another sheet next to final outcome with different bits to fill and use the different functions in excel
- the R code just renames the columns in the necessary way 

## EDITING IN BETWEEN: We do a lot of editing of the CSVs outside of R in excel and to do this: 
- i can't remember exactly where we edited stuff, i.e., the below was for the `eaf` which was given to me

### This is the breakdown of how to edit
- we create a new sheet that contains just the eaf values and the rest of the data we pull from and align next to our opened one (from step 2) which we name the table for `eaf` by clicking the right corner, highlighting and naming it  
- we use `=VLOOKUP($A2, eaf, 3, FALSE)` where: 
1. `$A2` is the value to look for.
2. `eaf` is the table range where it searches - to make this we select the entire table and rename it in the top right corner 
3. `3` means it returns the value from the third column of eaf.
4. `FALSE` ensures an exact match.
- `a2` is the column we are pasting to, `eaf` is the sheet that we have renamed next to our current sheet, and `3` is the column we are pulling info from
- then we do `control c` + `Paste Values` to remove the formatting and so it doesn't mess up in R

#### ALSO: the capitalisation of letters etc. is imperative and we need to change it manually in between sheets 
------
# MR Code

This is my process for working with GWAS summary statistics and Mendelian Randomization (MR).  
The script `all.R` contains all the necessary code.  

### **Files Used**
- **Exposure**: `DIAGRAMv3.2012DEC17.txt`
- **Outcome**: `meta_analysis_ukbb_summary_stats_finngen_R12_F5_ALZHDEMENT_meta_out.tsv`

---

## **Step 1 - Identifying Significant SNPs from DIAGRAMv3**
📌 **Lines 1-40 in `all.R`**  
- Applied a significance threshold of **1e-8** to filter SNPs.  
- Extracted the following columns:
  - `SNP`, `CHROMOSOME`, `POSITION`, `RISK_ALLELE`, `OTHER_ALLELE`, `P_VALUE`, `OR`, `OR_95L`, `OR_95U`, `N_CASES`, `N_CONTROLS`
- Calculated `log_or` and `SE` in R (**Lines 44-48**).  
- Saved as a `.csv` for manual editing.

---

## **Step 2 - Formatting the SNP Data**
📌 **Lines 50-57 in `all.R`**  
- Created `significant_snps_modified.csv` with the following columns:
  - `rsid`, `pval`, `chr`, `pos`, `pheno`, `beta`, `SE`, `effect_allele`, `eaf`, `units`, `gene`, `ncase`, `ncontrol`, `sample size`, `trait_id` (ieu-a-25), `z`, `info`
- Added:
  - `beta`, `z`, `info` (empty)
  - `trait = "diabetes"`
  - `samplesize = ncase + ncontrol`
- **Effect Allele Frequency (EAF)**:
  - Obtained from `exposure_data.xlsx`, originally derived from `ALL.wgs.phase3_shapeit2_mvncall_integrated_v5c.20130502.sites.vcf.gz.csi`
- Standardized column names for further analysis.

---

## **Step 3 - Clumping SNPs**
📌 **Lines 59-76 in `all.R`**  
- Performed LD-based clumping to remove SNPs that are too close together.  
- Created `clumped_snps.csv`, keeping only:
  - `rsid`, `pval`, and `id`  

---

## **Step 4 - Extracting SNPs from Finngen (Outcome: Dementia)**
📌 **Lines 80-89 in `all.R`**  
- Created a `.txt` file of SNPs: `alex_snps.txt`  
- Extracted outcome summary statistics from Finngen, producing `final_outcome_Alex.csv`

---

## **Step 5 - Formatting the Outcome Data**
- Edited `final_outcome_Alex.csv` to retain only:
  - `SNP`, `p-val`, `effect`, `SE`, `a1`, `a2`, `a1_freq` (EAF), `Units`, `Gene`, `n`
- Focused only on **Finngen data** (UKB integration is planned for later).  
- Renamed columns as required in R.

---

## **Step 6 - Formatting the Exposure Data**
- Created a formatted exposure dataset with:
  - `SNP`, `p-val`, `effect`, `SE`, `a1`, `a2`, `a1_freq` (EAF), `Units` (empty), `Gene` (empty), `n = 69k` (as stated in the study).
- Output saved as `outcome_data.csv`.  
- Some formatting was done in Excel before finalizing in R.

---

## **Editing CSVs in Excel**
Since a lot of formatting happened outside of R, here’s how we manually adjusted values in Excel.

### **Adding EAF Using Excel (`VLOOKUP`)**
To merge external EAF values into our dataset:
1. **Prepare the EAF Data**:  
   - Create a new sheet with EAF values aligned to SNPs.
   - Name the table by selecting it and assigning a name in the top-right corner.
2. **Use `VLOOKUP` to Pull EAF Data**:  
   ```excel
   =VLOOKUP($A2, eaf, 3, FALSE)


