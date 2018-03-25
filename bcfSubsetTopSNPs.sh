#!/bin/sh
#Use bcftools view to subset top SNPs for each trait from British VCFs
#Need txt file two column that lists files in same chromsome order
DIR=/Users/rotation/downloads
SNP_DIR=$DIR/euro_summary_stats/uk_traits/tophits5e-8/snp_regions
VCF_DIR=$DIR/1kgenomes/brit
OUTPUT_DIR=$DIR/1kgenomes/brit/traits
FILES_LIST=/Users/rotation/desktop/bcfsubset_looping/chrom_order.txt

cd $SNP_DIR
for trait in $SNP_DIR/*
do
  echo "Processing ${trait##*/}..."
  mkdir $OUTPUT_DIR/${trait##*/}
  while read -r a b
  do
    echo "Processing $a and $b"
    bcftools view -v snps -R $trait/$a -O z -o $OUTPUT_DIR/${trait##*/}/$b $VCF_DIR/$b
  done < $FILES_LIST
done
