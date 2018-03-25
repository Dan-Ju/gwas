#!/bin/sh
#create plink files from vcfs using plink2
#batch script of subdirectories containing chromososomes vcf

PLINK2_DIR=/Users/rotation/Applications/plink_mac
TRAIT_DIR=/Users/rotation/downloads/1kgenomes/brit/traits
OUTPUT_DIR=/Users/rotation/downloads/euro_summary_stats/uk_traits/BED-traits

cd $PLINK2_DIR

for trait in $TRAIT_DIR/*
do
  echo "Processing ${trait##*/}..."
  mkdir $OUTPUT_DIR/${trait##*/}
  for chrom in $trait/*
  do
    ./plink --vcf $chrom --out $OUTPUT_DIR/${trait##*/}/${chrom##*/}
  done
done
