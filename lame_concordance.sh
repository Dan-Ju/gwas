#!/bin/sh
#run naive concordance analysis

DIR=/Users/rotation/downloads
AFR=afr_summary_stats/1.mlma
EUR=euro_summary_stats/GIANT_height2.tbl
OUTPUT=/Users/rotation/desktop/test.tsv

Rscript --vanilla concordance.R $DIR/$AFR $DIR/$EUR $OUTPUT
