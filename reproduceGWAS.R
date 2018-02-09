# #################################################
## PROJECT: GWAS trans-ethnic reproducibility
## OBJECTIVE: Measure reproducibility of European GWAS hits  
## DATE: 2.08.2018
## AUTHOR: Dan Ju
# #################################################

## Notes
# -----------------------------
# ~ Input files: Two GWAS summary statistics tables 
# ~ Output: Table 
# ~ Takes top hits from first GWAS at some threshold and sees if there is 
#   replication of hit within a genomic window in other GWAS cohort
# ~ Determines concordance (i.e. same direct of effect) and distance of 
#   replicated hits across cohorts
# -----------------------------
checkConcordance.path <- "/Users/rotation/OneDrive/Tishkoff/scripts/checkConcordance.R"
source(checkConcordance.path)
library(parallel)

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

## Data import
# ----------------------------
eur.df <- read.table(eur_path, header=TRUE, as.is=TRUE) # beta corresponds to Allele1
afr.df <- read.table(afr_path, header=TRUE, as.is=TRUE) # beta is for A1 (minor allele)
gwas.hits <- eur.df[eur.df$p < quantile(eur.df$p, prob=1E-4), ]

# drop columns from African data frame
drops <- c('A2','Freq','se')
afr.df <- afr.df[ , !(names(afr.df) %in% drops)]
rows <- nrow(gwas.hits)
output.df <- data.frame(rsID = character(rows), chr = numeric(rows), 
                       pos = numeric(rows), p_eur = numeric(rows), 
                       beta_eur = numeric(rows),  
                       replicate = numeric(rows), 
                       eur_eff_allele = character(rows), 
                       stringsAsFactors = FALSE)

output.df$rsID <- gwas.hits$rsid
output.df$chr <- gwas.hits$chrom
output.df$pos <- gwas.hits$pos
output.df$p_eur <- gwas.hits$p
output.df$beta_eur <- gwas.hits$b
output.df$eur_eff_allele <- gwas.hits$Allele1

# vectors
k.vec <- numeric(rows)
afr.pos.vec <- numeric(rows)
afr.al.vec <- character(rows)
afr.b.vec <- numeric(rows)
afr.p.vec <- numeric(rows)
chr.vec <- gwas.hits$chrom
beg_wind <- gwas.hits$pos - window_size/2
end_wind <- gwas.hits$pos + window_size/2

for (i in 1:rows) {
  temp.df <- subset(afr.df, Chr == chr.vec[i] & bp <= end_wind[i] 
                    & bp >= beg_wind[i])
  hit_index <- which(temp.df$p==min(temp.df$p))
  
  afr.p.vec[i] <- temp.df$p[hit_index]
  afr.b.vec[i] <- temp.df$b[hit_index]
  afr.al.vec[i] <- temp.df$A1[hit_index]
  afr.pos.vec[i] <- temp.df$bp[i]
  
  k <- nrow(temp.df)
  k.vec[i] <- k
  rm(temp.df)
}

# add vectors to output df
output.df$k <- k.vec
output.df$afr_pos <- afr.pos.vec
output.df$afr_eff_allele <- afr.al.vec
output.df$beta_afr <- afr.b.vec
output.df$p_afr <- afr.p.vec

# check if significant
output.df$p_adj <- 1 - 0.95^(1/output.df$k)
output.df$replicate[which(output.df$p_afr <= output.df$p_adj)] <- 1

# find distance between the afr and eur hits
output.df$distance <- output.df$afr_pos - output.df$pos

# check concordance
final.output <- checkConcordance(output.df)

# export as .tsv
write.table(final.output, export_path, sep="\t")
