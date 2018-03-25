#!/bin/sh
#Extract chromosome and pos from directory of top SNPs
#Puts regions file in specified directory for each chromosome

DIR=/Users/rotation/Downloads/euro_summary_stats/uk_traits/tophits5e-8
INPUT_DIR=$DIR/all_traits/9.uk_tophits.tsv_chr
OUTPUT_DIR=$DIR/snp_regions/9

cd $DIR

for f in ${INPUT_DIR}/*
do
  awk -v OFS='\t' '{print $1,$3}' $f > $OUTPUT_DIR/chrpos_${f##*/}
done
