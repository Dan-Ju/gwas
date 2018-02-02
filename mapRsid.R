#!/usr/bin/env Rscript
# -----------------------------
#  Look up chromosome & position for SNPs in a data frame and export as .tab file.
# -----------------------------
args = commandArgs(trailingOnly=TRUE) # arg1 = dataset with rsIDs
                                      # arg2 = path to exported file with chrom:pos
library(methods)
library(biomaRt)
df <- read.table(args[1], header=TRUE, as.is=TRUE)
hsapiens.grch37 <- useEnsembl(biomart = "snp", dataset="hsapiens_snp", GRCh=37)
snp_loc <- getBM(attributes = c("refsnp_id", "chr_name", "chrom_start", "chrom_end"), 
                 filters = "snp_filter", 
                 values = df$MarkerName,
                 mart = hsapiens.grch37)
colnames(snp_loc)[1] <- colnames(df)[1]
df <- merge(df, snp_loc, by = "MarkerName", all.x=FALSE)
df$SNP <- paste(df$chr_name, ":", df$chrom_start, sep="")
export.path <- args[2]
write.table(df, export.path, sep="\t")
