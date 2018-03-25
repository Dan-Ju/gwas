#!/bin/sh
#Batch version of DOE.sh (two directories with traits)
#
#Direction of effect concordance analysis
#Need $TRAITS file with number coded traits common to both cohorts
#Looks from gwas file of significant hits to see if same DOE as in Africans

DIR2=/Users/rotation/downloads/afr_summary_stats/run5/
EXT2=mlma
DIR1=/Users/rotation/downloads/gwas_catalog/traits/
EXT1=gwas
OUTPUT_DIR=/Users/rotation/desktop/DOE_output
RFILE_DOE=/Users/rotation/OneDrive/Tishkoff/scripts/directionofEffect.R
RFILE_SIGN=/Users/rotation/OneDrive/Tishkoff/scripts/gwasSignTest.R
TRAITS=/Users/rotation/desktop/gwas_catalog_traits.txt
SIGNTEST_RESULTS=/Users/rotation/desktop/signtest_results.txt

touch $SIGNTEST_RESULTS
while read -r a
do
  echo "Processing trait ${a}..."
  touch $OUTPUT_DIR/${a}.txt
  for chrom in {1..22}
  do
    echo "Processing chromosome ${chrom}"
    Rscript --vanilla $RFILE_DOE ${DIR1}/${a}.${EXT1}_chr/${chrom}_${a}.$EXT1 \
    ${DIR2}/${a}.${EXT2}_chr/${chrom}_${a}.$EXT2 $OUTPUT_DIR/${a}.txt $EXT1
  done
  echo "Trait ${a}" >> $SIGNTEST_RESULTS
  Rscript --vanilla $RFILE_SIGN $OUTPUT_DIR/${a}.txt >> $SIGNTEST_RESULTS
done < $TRAITS
