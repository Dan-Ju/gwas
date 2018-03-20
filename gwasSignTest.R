#Sign test on output from directionofEffect.R
args = commandArgs(trailingOnly = TRUE) 
# arg1 is output table from directionofEffect.R

df <- read.table(args[1], as.is = TRUE)

concord.count <- nrow(df[df$V15==1,])
total.count <- nrow(df) 
btest <- binom.test(concord.count, total.count)

# extract info from test object
percent <- concord.count / total.count
p <- btest[[3]]

print(c("Percent concordant:", percent))
print(c("Concordant SNPs:", concord.count))
print(c("Total SNPs:", total.count))
print(c("Sign test p-value:", p))