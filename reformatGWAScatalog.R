## Convert GWAS catalog summary stats into usable formats for scripts

args = commandArgs(trailingOnly = TRUE) 
# arg1 path to GWAS catalog file as csv
# arg2 flag for which ancestry (EUR, EAS, AFR)
# arg3 path for output file

library(biomaRt)

catalog.df <- read.csv(args[1], as.is=TRUE)

columns_to_keep <- c('SNPS','INITIAL.SAMPLE.SIZE','STRONGEST.SNP.RISK.ALLELE',
                     'P.VALUE','X95..CI..TEXT.')

filt.catalog.df <- subset(catalog.df, P.VALUE <= 5e-8, select = columns_to_keep)

# get SNPs from specific ancestries
if(args[2] == 'EUR') {
  pop_to_keep <- c('Brit|Europe|Sorbia|Mylopotamos|Sardinia|Finn|Amish|Friuli')
  } else if (args[2] == 'EAS') {
    pop_to_keep <- c('Chinese|Korea|Vietnam|Japan|East Asia|')
    } else if (args[2]== 'AFR') {
      pop_to_keep <- c('Africa|Nigeria')
    }
  

keep_index <- grep(pop_to_keep, filt.catalog.df$INITIAL.SAMPLE.SIZE)
filt.catalog.df <- filt.catalog.df[keep_index, ]

# Extract risk allele
snp.allele <- t(data.frame(strsplit(filt.catalog.df$STRONGEST.SNP.RISK.ALLELE,'-')))
filt.catalog.df$A1 <- snp.allele[ ,2]
filt.catalog.df <- filt.catalog.df[filt.catalog.df$A1 != '?',]

# clean data - remove duplicates and no direction of effect
filt.catalog.df <- filt.catalog.df[which(filt.catalog.df$X95..CI..TEXT.!='[NR]'
                                         & filt.catalog.df$X95..CI..TEXT.!=''),]
filt.catalog.df <- filt.catalog.df[!(duplicated(filt.catalog.df$SNPS)), ]

# get coordinates for Grch37
hsapiens.grch37 <- useEnsembl(biomart = "snp", dataset="hsapiens_snp", GRCh=37)
snp_loc <- getBM(attributes = c("refsnp_id", "chr_name", "chrom_start"), 
                 filters = "snp_filter", 
                 values = filt.catalog.df$SNPS,
                 mart = hsapiens.grch37)

colnames(snp_loc)[1] <- 'SNPS'
catalog.loc.df <- merge(snp_loc, filt.catalog.df, by='SNPS')
increase.index <- grep("increase", catalog.loc.df$X95..CI..TEXT.)
decrease.index <- grep("decrease", catalog.loc.df$X95..CI..TEXT.)
catalog.loc.df$b <- NA
catalog.loc.df$b[increase.index] <- 1 
catalog.loc.df$b[decrease.index] <- -1

# reformat for final output
rows <- nrow(catalog.loc.df)
output.df <- data.frame(Chr = numeric(rows), 
                        bp = numeric(rows), 
                        A1 = character(rows),
                        b = numeric(rows),
                        p = numeric(rows),
                        stringsAsFactors = FALSE)
output.df$Chr <- catalog.loc.df$chr_name
output.df$bp <- catalog.loc.df$chrom_start
output.df$A1 <- catalog.loc.df$A1
output.df$b <- catalog.loc.df$b
output.df$p <- catalog.loc.df$P.VALUE

write.table(output.df, file = args[3], sep = "\t", row.names = FALSE)