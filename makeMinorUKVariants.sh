#!/bin/sh
# Convert allele1 and frequency of variants.tsv from Uk biobank to minor allele

cd /Users/rotation/downloads/euro_summary_stats/variants

awk '{print $1}' variants.tsv |
awk -F ":" 'BEGIN{OFS="\t"}{print $1,$2,$3,$4}' > chr_pos_ref_alt.tsv

awk 'BEGIN{OFS="\t"}{
  chr=$1; pos=$2; ref=$3; alt=$4;
  getline < "variants.tsv";
  if ($4 >= 0.5)
    print chr, pos, ref, alt,1-$4 > "variants_MAF.tsv";
  else
    print chr, pos, alt, ref, $4 > "variants_MAF.tsv"}' chr_pos_ref_alt.tsv
