#!/bin/sh
#Reformat UKbiobank GWAS table to Matt's format

DIR=/Users/rotation/downloads/euro_summary_stats/right_grip
UKFILE=right_grip.tsv
FQFILE=/Users/rotation/downloads/euro_summary_stats/variants/variants_MAF.tsv
OUTPUT=10_R.uk

cd $DIR

awk '{print $1}' $UKFILE | awk -F ":" 'BEGIN{OFS="\t"}{print $1,$2,$3,$4}' \
> chr_pos_allele.tsv

python /Users/rotation/OneDrive/Tishkoff/scripts/reformatUKtable.py \
-o $OUTPUT -v chr_pos_allele.tsv -m $UKFILE -f $FQFILE
