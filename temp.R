args = commandArgs(trailingOnly = TRUE) 
# arg1 path to bed tools intersect output bed file
# arg2 path to bed tools intersect output bed file

df1 <- read.table(args[1], as.is = TRUE)
df2 <- read.table(args[2], as.is = TRUE)

df <- merge(eur.filt, afr.filt, by="V4")


eur_mean <- mean(df$V5.x)
afr_mean <- mean(df$V5.y)
eur_sd <- sd(df$V5.x)
afr_sd <- sd(df$V5.y)
df$eurz <- (df$V5.x - eur_mean) / eur_sd
df$afrz <- (df$V5.y - afr_mean) / afr_sd
df$sum <- df$eurz + df$afrz
