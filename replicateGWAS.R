# #################################################
## PROJECT: GWAS trans-ethnic replication
## OBJECTIVE: Measure replication of GWAS hits in one file in another
## DATE: 3.09.2018
## AUTHOR: Dan Ju
# #################################################

## Notes
# -----------------------------
# ~ Input: Directory for chromosomes 
# ~ Output: Table 
# ~ Takes top hits from first GWAS at some threshold and sees if there is 
#   replication of hit within a genomic window in other GWAS cohort
# ~ Determines concordance (i.e. same direct of effect) and distance of 
#   replicated hits across cohorts
# -----------------------------

checkConcordance.path <- "/Users/rotation/OneDrive/Tishkoff/scripts/checkConcordance.R"
source(checkConcordance.path)

args = commandArgs(trailingOnly = TRUE) 
args = c('/Users/rotation/downloads/euro_summary_stats/ukbio_height_chrpos.tsv',
         '/Users/rotation/downloads/afr_summary_stats/1.mlma',
         2e5, 
         '/Users/rotation/desktop/test_reproduceGWAS.tsv')
# Arg1 is path to EUR GWAS summary stats
# Arg2 is path to AFR GWAS summary stats
# Arg3 is genomic window size
# Arg4 is path for exporting output table
eur_path <- args[1]
afr_path <- args[2]
window_size <- as.numeric(args[3])
export_path <- args[4]

