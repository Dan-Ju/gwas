#!/bin/sh
#Direction of effect concordance analysis
#Looks from gwas file of significant hits to see if same DOE as in Africans

TRAIT=1
DIR2=/Users/rotation/downloads/afr_summary_stats/run5/1.mlma_chr
EXT2=mlma
DIR1=/Users/rotation/downloads/gwas_catalog/traits/1.gwas_chr
EXT1=gwas
OUTPUT=/Users/rotation/desktop/testing.tsv
RFILE=/Users/rotation/OneDrive/Tishkoff/scripts/directionofEffect.R
RFILE_DOE=/Users/rotation/OneDrive/Tishkoff/scripts/gwasSignTest.R

touch $OUTPUT
for chrom in {1..22}
do
  echo "Processing chromosome $chrom"
  Rscript --vanilla $RFILE ${DIR1}/${chrom}_${TRAIT}.$EXT1 \
  ${DIR2}/${chrom}_${TRAIT}.$EXT2 $OUTPUT
done

Rscript --vanilla $RFILE_DOE $OUTPUT
