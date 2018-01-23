# #################################################
## PROJECT: GWAS trans-ethnic reproducibility
## OBJECTIVE: Measure concordance between European GWAS associations and African 
## DATE: 1.15.2017
## AUTHOR: Dan Ju
# #################################################

## Notes
# -----------------------------
# ~ Script looks at one trait and compares GWAS summary statistics between Africans and Europeans
# ~ 
# -----------------------------

## Libraries, paths, args, etc.
# -----------------------------
library(plyr)
#args = commandArgs(trailingOnly = TRUE) # Arg1 is path to African GWAS summary stats
                                        # Arg2 is path to European GWAS summary stats
eur.path <- '/Users/rotation/downloads/euro_summary_stats/GIANT_HEIGHT_Wood_et_al_2014_publicrelease_HapMapCeuFreq'
afr.path <- '/Users/rotation/downloads/afr_summary_stats/1.mlma'

## Data import
# ----------------------------
eur.df <- read.table(eur.path, header = TRUE, as.is = TRUE) # beta corresponds to allele1 probably
afr.df <- read.table(afr.path, header = TRUE, as.is = TRUE) # beta is for A1 (minor allele)

## chr:pos for European rsIDs
# ----------------------------
# European GWAS results uses rsIDs, so need to look up genomic location 
# in order to merge African and European data frames. Then merge data.
# ----------------------------
library(biomaRt)
hsapiens.grch37 <- useEnsembl(biomart = "snp", dataset = "hsapiens_snp", GRCh = 37)
snp_loc <- getBM(attributes = c("refsnp_id", "chr_name", "chrom_start", "chrom_end"), 
                 filters = "snp_filter", 
                 values = eur.df$MarkerName,
                 mart = hsapiens.grch37)
colnames(snp_loc)[1] <- colnames(eur.df)[1]
eur.df <- merge(eur.df, snp_loc, by = "MarkerName", all.x = FALSE)
eur.df$SNP <- paste(eur.df$ chr_name, ":", eur.df$chrom_start, sep = "")
merged.df <- merge(eur.df, afr.df, by = "SNP")
## SNP curation
# -----------------------------
# SNPs that meet a p-value condition for the African/European datasets
# are collected individually and then summary stats for these SNPs are
# merged into one data frame. P-value conditions are as follows:
# p_group1 p <= 0.001
# p_group2 0.001 < p <= 0.01
# p_group3 0.01 < p <= 0.5
# p_group4 0.5 < p <= 1
# -----------------------------
# categorize SNPs by p-value 
eur$d
eur.filt <- subset(eur.df, p < p.threshold)
afr.filt <- subset(afr.df, p < p.threshold)


# specify p, beta, effect allele ancestry 
colnames(afr.ht.filt)[which(colnames(afr.ht.filt) %in% c("p","se","b","A1"))] <- c("afr_eff_allele","b_afr",
                                                                                   "SE_afr","p_afr")
colnames(giant.filt)[which(colnames(giant.filt) %in% c("p","SE","b","Allele1"))] <- c("eur_eff_allele","b_eur",
                                                                                      "SE_eur","p_eur")
# merge african and european datasets
afr.eur.df <- merge(giant.filt, afr.ht.filt, by = "SNP", all.x = FALSE)

# check concordance
afr.eur.df$effect_allele_same <- 0
afr.eur.df$effect_allele_same[which(afr.eur.df$eur_eff_allele == afr.eur.df$afr_eff_allele)] <- 1
afr.eur.df$b_product <- NA
afr.eur.df$b_product <- afr.eur.df$b_eur * afr.eur.df$b_afr
afr.eur.df$concordance <- NA
afr.eur.df$concordance[ which (
                              afr.eur.df$effect_allele_same == 1 & afr.eur.df$b_product > 0 |
                              afr.eur.df$effect_allele_same == 0 & afr.eur.df$b_product < 0  
                              )] <- 1
afr.eur.df$concordance[ which (
                              afr.eur.df$effect_allele_same == 0 & afr.eur.df$b_product > 0 |
                              afr.eur.df$effect_allele_same == 1 & afr.eur.df$b_product < 0  
                              )] <- 0
# sign test
fq.col <- ldply(afr.eur.df, function(c) sum(c==1))
rownames(fq.col) <- fq.col[ , 1]
concord.count <- fq.col["concordance",2]
total.count <- nrow(afr.eur.df) 
btest <- binom.test(concord.count, total.count)
