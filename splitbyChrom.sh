#!/bin/sh
#Split up GWAS summary table into separate tables by chromosome into new folder
#Batch processes all GWAS trait files in a folder
#FIRST COLUMN MUST BE CHROMOSOME NUMBER

DIR=/Users/rotation/downloads/euro_summary_stats/uk_traits/tophits5e-8/all_traits
EXTENSION=tsv

cd $DIR
for f in ${DIR}/*.${EXTENSION}
do
  echo "Processing ${f##*/}..."
  mkdir ${f##*/}_chr
  for chrom in {1..22}
  do
    awk -v chr=$chrom '$1==chr {print $0}' ${f##*/} > \
    ${f##*/}_chr/${chrom}.tsv
  done
done
