#!/bin/sh
#Find closest gene to SNP
#Determine gene enrichment and distribution of SNP distance to genes
#getTopHits.py needed
####Run findGeneEnrich before this with desired quantile####

DIR=/Users/rotation/downloads/euro_summary_stats/uk_traits
GENE_FILE=/Users/rotation/downloads/all-genes/genes_RefSeq_0kb.bed
PYTHON_SCRIPT_LOC=/Users/rotation/OneDrive/Tishkoff/scripts
OUTPUT_FOLDER=/Users/rotation/downloads/euro_summary_stats/closest_gene
QUANTILE=0.0001
EXTENSION=uk

for f in ${DIR}/*.${EXTENSION}
do
  echo "Processing ${f##*/}..."

  cd ${DIR}
  cd ./${f##*/}_tophits$QUANTILE

  bedtools closest -d -b $GENE_FILE -a ${f##*/}_tophits.bed \
  > ${OUTPUT_FOLDER}/closest_genes_${f##*/}_${QUANTILE}.bed
done
