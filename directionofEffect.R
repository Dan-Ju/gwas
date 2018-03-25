# #################################################
## PROJECT: GWAS direction of effect replication
## OBJECTIVE: Measure replication of GWAS hits in one file in another
## DATE: 3.13.2018
## AUTHOR: Dan Ju
# #################################################

## Notes
# -----------------------------
# ~ Input: Directory for chromosomes 
# ~ Output: Table 
# ~ Takes top hits from first GWAS at some threshold and sees if direction of 
#   effect is same
# -----------------------------
checkConcordance.path <- "/Users/rotation/OneDrive/Tishkoff/scripts/checkConcordance.R"
source(checkConcordance.path)

args = commandArgs(trailingOnly = TRUE) 
# arg1 is file with GWAS hits to be analyzed separated by chromosome
# arg2 is path to directory with African GWAS separated by chromosome
# arg3 is file to append output to
# arg4 flags whether it is .gwas or .uk format

df1.temp <- read.table(args[1], as.is = TRUE)
df2.temp <- read.table(args[2], as.is = TRUE)
# if R does something stupid with reading Ts
df1.temp$V3[which(df1.temp$V3=="TRUE")] <- "T"
df2.temp$V4[which(df2.temp$V4=="TRUE")] <- "T"

index.df2 <- match(df1.temp$V2, df2.temp$V3)
df2.temp <- df2.temp[index.df2, ]
colnames(df2.temp)[c(1,3,4,7,9)] <- c('Chr','bp','df2_eff_allele','b_df2','p_df2')
if(args[4]=='gwas'){
  colnames(df1.temp) <- c('Chr','bp','df1_eff_allele','b_df1','p_df1')
} else if(args[4]=='uk'){
  colnames(df1.temp)[c(1,3,4,7,9)] <- c('Chr','bp','df1_eff_allele','b_df1','p_df1')
}

comb.df <- merge(df1.temp, df2.temp, by = c("Chr","bp"))

final.df <- checkConcordance(comb.df)
write.table(final.df, file = args[3], sep = "\t", append = TRUE, col.names = FALSE,
            row.names = FALSE)
