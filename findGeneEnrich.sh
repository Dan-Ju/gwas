#!/bin/sh
#Batch version of findGeneGWAS.sh
#Take GWAS output files in folder and find top hits and overlap with genes
#Use editBedPos.sh to alter window size of genes
#getTopHits.py needed

DIR=/Users/rotation/downloads/euro_summary_stats/uk_traits
GENE_FILE=/Users/rotation/downloads/all-genes/genes_RefSeq_500000kb.bed
QUANTILE=0.0001
PYTHON_SCRIPT_LOC=/Users/rotation/OneDrive/Tishkoff/scripts
OUTPUT_FOLDER=/Users/rotation/downloads/euro_summary_stats/gene_enrichment_500kb
EXTENSION=uk

for f in ${DIR}/*.${EXTENSION}
do
  echo "Processing ${f##*/}..."

  cd ${DIR}
  # mkdir ${f##*/}_tophits$QUANTILE
  cd ./${f##*/}_tophits$QUANTILE

  # python $PYTHON_SCRIPT_LOC/getTopHits.py -o ${f##*/}_tophits.tsv \
  # -i ${DIR}/${f##*/} -q $QUANTILE
  #
  # awk -v OFS='\t' 'FNR > 1 { print "chr" $2,$4-1,$4 }' ${f##*/}_tophits.tsv > \
  # ${f##*/}_tophits.bed

  bedtools intersect -c -a $GENE_FILE -b ${f##*/}_tophits.bed \
  > ${OUTPUT_FOLDER}/enriched_genes_${f##*/}_${QUANTILE}.bed
done
