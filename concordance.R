# #################################################
## PROJECT: GWAS trans-ethnic reproducibility
## OBJECTIVE: Measure concordance between European GWAS associations and African 
## DATE: 1.15.2017
## AUTHOR: Dan Ju
# #################################################

## Notes
# -----------------------------
# ~ Script looks at one trait and compares GWAS beta value concordance between 
#   Africans and Europeans.
# ~ This is a naive version that compares SNP to SNP concordance at various   
#   p-value thresholds for African and European summary statistics.
# ~ Outputs a table with proportions of loci that have same direction and 
#   p-values from one-sided sign test. 
# -----------------------------

## Libraries, paths, args, etc.
# -----------------------------
checkConcordance.path <- "/Users/rotation/OneDrive/Tishkoff/scripts/checkConcordance.R"
source(checkConcordance.path)

args = commandArgs(trailingOnly = TRUE) 
# Arg1 is path to African GWAS summary stats
# Arg2 is path to European GWAS summary stats
# Arg3 is path for exporting output table
eur.path <- args[2]
afr.path <- args[1]
export.path <- args[3]

## Data import
# ----------------------------
eur.df <- read.table(eur.path, header=TRUE, as.is=TRUE) # beta corresponds to allele1 probably
afr.df <- read.table(afr.path, header=TRUE, as.is=TRUE) # beta is for A1 (minor allele)

## Label columns by ancestry and merge
# ----------------------------
colnames(afr.df)[which(colnames(afr.df) %in% c("p","se","b","A1"))] <- 
    c("afr_eff_allele","b_afr","SE_afr","p_afr")
colnames(eur.df)[which(colnames(eur.df) %in% c("p","SE","b","Allele1"))] <- 
  c("eur_eff_allele","b_eur","SE_eur","p_eur")
merged.df <- merge(eur.df, afr.df, by = "SNP")

## SNP curation
# -----------------------------
# SNPs that meet a p-value condition in either the African/European datasets are 
# grouped by a categorical variable. P-value groups are:
# 1) p <= 5E10^-8
# 2) 5E10^-8 < p <=10^-5
# 3) 10^-5 < p <= 0.001
# 4) 0.001 < p <= 0.01
# 5) 0.01 < p <= 0.5
# 6) 0.5 < p <= 1
# SNPs in each group are further filtered by a minimum distance from each other.
# SNPs are first split into p-value groups and then starting from one end of 
# chromosome to other are selected for concordance analysis if they are 
# 500 kb apart. Concordance groups follow same categorization scheme as p-value
# groups. 
# -----------------------------
# categorize SNPs by p-value
merged.df$p_cat_afr <- NA
merged.df$p_cat_eur <- NA
merged.df$p_cat_fin <- NA

catSnpAfr <- function(i ,p1, p2, df.in) {
  df.in$p_cat_afr[which(df.in$p_afr > p1 & df.in$p_afr <= p2)] <- i
  return(df.in)
}
catSnpEur <- function(i ,p1, p2, df.in) {
  df.in$p_cat_eur[which(df.in$p_eur > p1 & df.in$p_eur <= p2)] <- i
  return(df.in)
}

list.pval <- c(10^-300,5*10^-8,10^-5,0.001,0.01,0.5,1)
for (i in 1:length(list.pval)-1) {
  merged.df <- catSnpEur(i, list.pval[i], list.pval[i+1], merged.df)
  merged.df <- catSnpAfr(i, list.pval[i], list.pval[i+1], merged.df)
}
# assign SNP to lower p-value group
afr.low <- which(merged.df$p_cat_afr <= merged.df$p_cat_eur)
eur.low <-which(merged.df$p_cat_eur <= merged.df$p_cat_afr)
merged.df$p_cat_fin[afr.low] <- merged.df$p_cat_afr[afr.low]
merged.df$p_cat_fin[eur.low] <- merged.df$p_cat_eur[eur.low]

# pick SNPs separated by minimum distance
min.dist <- 1e5
merged.df$concord_group <- 0
for (i in 1:6) {
  for (j in 1:23) {
    index <- which(merged.df$p_cat_fin==i & merged.df$chr_name==j)
    merged.df$concord_group[index] <- i 
    temp.df <- merged.df[merged.df$concord_group==i, c("bp","SNP")]
    temp.df$dist[2:length(temp.df$bp)] <- diff(temp.df$bp)
    temp.df$remove <- 0
    
    cum.dist <- 0
    for (k in 2:length(temp.df$bp)) { # iterate along chromosome
      cum.dist <- cum.dist + temp.df$dist[k]
      if (cum.dist > min.dist) {
        cum.dist <- 0 
      }
      else {
        temp.df$remove[k] <- 1
      }
    }
    index.remove <- which(merged.df$SNP %in% temp.df$SNP[temp.df$remove==1])
    merged.df$concord_group[index.remove] <- 0
  }
}
# empty data frame for concordance analysis results  
p.val.groups <- c('p <= 5E10^-8','5E10^-8 < p <=10^-5', '10^-5 < p <= 0.001',
                  '0.001 < p <= 0.01', '0.01 < p <= 0.5', '0.5 < p <= 1')
final.df <- data.frame(p.val.groups, concordant = numeric(6), 
                       totalSNPs = numeric(6), percent = numeric(6), 
                       p = numeric(6))
colnames(final.df)[1] <- 'P-value threshold'

for (i in 1:6) {
  test.df <- checkConcordance(merged.df[merged.df$concord_group==i, ])
  # perform sign test
  concord.count <- length(test.df$SNP[test.df$concordance==1])
  total.count <- nrow(test.df) 
  btest <- binom.test(concord.count, total.count)
  rm(test.df)
  # extract info from test object
  percent <- concord.count / total.count
  p <- btest[[3]]
  insert <- c(concord.count, total.count, percent, p)
  final.df[i, 2:5] <- insert
}

# export as .tsv
write.table(final.df, export.path, sep="\t")
