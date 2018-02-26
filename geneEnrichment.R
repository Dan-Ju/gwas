## Gene Enrichment analysis 
# NOTE: Total number of genes is hardcoded in according to RefSeq gene list
args = commandArgs(trailingOnly = TRUE) 
# arg1 path to bed tools intersect output bed file
# arg2 path to bed tools intersect output bed file

library(methods)
library(biomaRt)
library(dplyr)
df1 <- read.table(args[1], as.is = TRUE)
df2 <- read.table(args[2], as.is = TRUE)

hsapiens.grch37 <- useEnsembl(biomart = "ensembl", dataset="hsapiens_gene_ensembl",
                              GRCh=37)

genes <- getBM(attributes = c("chromosome_name", "start_position", "refseq_mrna",
                                  "end_position", "hgnc_symbol", "hgnc_id"), 
                   values = df1$V4,
                   filters = "refseq_mrna",
                   mart = hsapiens.grch37)
genes.dedup <- genes[!(duplicated(genes$hgnc_symbol)), ]

# get rid of transcripts with no hits
df1 <- subset(df1, V5>0)
df2 <- subset(df2, V5>0)

genes.df1 <- getBM(attributes = c("chromosome_name", "start_position", "refseq_mrna",
                                 "end_position", "hgnc_symbol", "hgnc_id"), 
                   values = df1$V4,
                   filters = "refseq_mrna",
                   mart = hsapiens.grch37)
genes.df1 <- genes.df1[!(duplicated(genes.df1$hgnc_symbol)), ]

genes.df2 <- getBM(attributes = c("chromosome_name", "start_position", "refseq_mrna",
                                  "end_position", "hgnc_symbol", "hgnc_id"), 
                   values = df2$V4,
                   filters = "refseq_mrna",
                   mart = hsapiens.grch37)
genes.df2 <- genes.df2[!(duplicated(genes.df2$hgnc_symbol)), ]

intersect.df <- merge(genes.df1, genes.df2, by=c("hgnc_id","chromosome_name",
                                                 "start_position","end_position",
                                                 "refseq_mrna","hgnc_symbol"))

q_intersect <- nrow(intersect.df)
m_hits <- nrow(genes.df1)
n_nothits <- nrow(genes.dedup) - m_hits
k_draws <- nrow(genes.df2)

p <- 1 - phyper(q_intersect,m_hits,n_nothits,k_draws)
print(c("Hypergeometric test:",p))
print(c("Intersecting genes:", q_intersect))
print(c("Arg1 data gene hits:", m_hits))
print(c("Arg2 data gene hits:", k_draws))
