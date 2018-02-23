#!/bin/sh
#Change gene coordinates bed file for bedtools intersect analysis to reflect
#window size

DIR=/Users/rotation/downloads/all-genes #where gene.bed file is
GENE_FILENAME=genes_RefSeq.bed
WIND_SIZE=200000 #total window size

cd $DIR
WIND=$((WIND_SIZE / 2))

echo | awk -v size=$WIND '{ print $1,$2-size,$3+size,$4 }' $GENE_FILENAME | \
awk -v OFS='\t' '{ if ($2 < 0) print $1,$2,$3,$4; else print $1,$2,$3,$4 }' \
> genes_RefSeq_${WIND_SIZE}kb.bed
