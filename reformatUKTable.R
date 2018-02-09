## Convert UK biobank GWAS summary stats into usable formats for scripts

args = commandArgs(trailingOnly = TRUE) # arg1 path to original UK file
                                        # arg2 path to file with chr, pos, ref, alt
                                        # arg2 path for exported table
library(ff)
args <- c('/Users/rotation/downloads/euro_summary_stats/height_ukbio.tsv',
          '/Users/rotation/downloads/euro_summary_stats/height_ukbio_column1delim.tsv',
          '/Users/rotation/downloads/euro_summary_stats/ukbio_height_chrpos.tsv')
uk.df <- read.table(file = args[1], header = TRUE)
uk.pos <- read.table(file = args[2])

# bind by columns
final.df <- cbind(uk.pos, uk.df)
colnames(final.df)[1:4] <- c('chrom','pos','ref','Allele1')
# rename columns so they are compatible with concordance.R
columns.uk <- c("beta", "se", "pval")
columns.eur <- c("b", "SE", "p")
colnames(final.df)[which(colnames(final.df) %in% columns.uk)] <- columns.eur
# create SNP column for merging if needed
final.df$SNP <- paste(final.df$chrom, ":", final.df$pos, sep="")

export.path <- args[3]
write.table(final.df, export.path, sep="\t")
