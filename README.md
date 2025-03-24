# MR_code
This is me trying to figure out how to use GWAS info. 
I am using the following files: `DIAGRAMv3.2012DEC17.txt` (exposure) and `meta_analysis_ukbb_summary_stats_finngen_R12_F5_ALZHDEMENT_meta_out.tsv` (outcome) 

#### Step 1: Find the most significant snps
this is done using the script `test1.R`

#### Step 2: Clumping 
this is correctly done using test2.R 
- if running after a while you get the error `could not find ld_clump` just run all the libraries ever - refer to the one big document which is `all.R` which has all the significant snps and the clumping 

### Step 3: Formatting the outcome based on the clumped snps 
- run outcome_form.R which is a bless script that gets out the necessary info from the outcome - then we can try get eaf to add on too
- why the hell are my effect alleles and other alleles different or flipped - whats chat gpt saying on this matter? that i should flip them back manually 


