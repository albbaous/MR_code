# MR_code
Just trynna figure out an MR pipeline for selecting instrumental variables from GWAS catalog
- So I am doing 2-sample MR with Biobank data and GWAS Catalog to avoid overfitting - if i tried 3 sample, datasets would be TOO different
---

#### **Step 1: Define the Research Question**
- Identify the exposure  X and outcome Y of interest.
- X can be environmental or genetic - Y is definitely dementia 

---

#### **Step 2: Select Genetic Instruments**
1. **Identify Variants**:
   - Use GWAS summary statistics to find variants strongly associated with \( X \) (e.g., \( p < 5 \times 10^{-8} \)).
   - Check the strength of instruments using the F-statistic (\( F > 10 \)).
   





