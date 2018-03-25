#!/bin/sh
#plink LD prune directory of trait subdirectories
#output directory of traits with SNPs to include

PLINK2_DIR=/Users/rotation/Applications/plink_mac
BED_DIR=/Users/rotation/downloads/euro_summary_stats/uk_traits/BED-traits
OUTPUT_DIR=/Users/rotation/downloads/euro_summary_stats/uk_traits/pruned
WINDOW=50
R2=0.5
SHIFT=5

cd $PLINK2_DIR
for trait in $BED_DIR/*
do
  echo "Processing ${trait##*/}..."
  mkdir $OUTPUT_DIR/${trait##*/}
  for chrom in $trait/*.bed
  do
    chr=${chrom##*/}
    TEMP_LENGTH=${#chr}
    # echo ${chr:0:$TEMP_LENGTH-4}
    ./plink --indep-pairwise $WINDOW $SHIFT $R2 \
    --bfile $trait/${chr:0:$TEMP_LENGTH-4} \
    --out $trait/$chr
  done
done
