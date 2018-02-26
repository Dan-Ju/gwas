#!/bin/sh
#Reformat UKbiobank GWAS table to Matt's format

DIR=/Users/rotation/downloads/euro_summary_stats/height
UKFILE=height_ukbio.tsv
OUTPUT=reformat_height_uk.tsv

cd $DIR

awk '{print $1}' $UKFILE | awk -F ":" 'BEGIN{OFS="\t"}{print $1,$2,$3,$4}' \
> chr_pos_allele.tsv

python /Users/rotation/OneDrive/Tishkoff/scripts/reformatUKtable.py \
-o $OUTPUT -v chr_pos_allele.tsv -m $UKFILE
