## GetTopHitsGWAS
# Take GWAS file and outputs top hits based on user specified p-value

args = commandArgs(trailingOnly = TRUE) # arg1 is input 
                                        # arg2 is output
                                        # arg3 is p
input_path <- args[1]
export_path <- args[2]
p_val <- as.numeric(args[3])

gwas.df <- read.table(input_path, header=TRUE, as.is=TRUE)
hits.df <- gwas.df[gwas.df$p < p_val, ]

write.table(hits.df, export_path, sep="\t")