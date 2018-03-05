#!/bin/sh
#Run geneEnrichment.R as batch process for African GWAS data and corresponding
#requires a text file with two processed GWAS bed files per line
#compiles final statistics in one txt file
#DIFFERENT R SCRIPTS FOR DOING GENE ENRICHMENT DEPENDING ON WHETHER BED FILE
  #IS PER GENE OR PER SNP

DIR=/Users/rotation/downloads

# RSCRIPT=/Users/rotation/OneDrive/Tishkoff/scripts/geneEnrichment.R
RSCRIPT=/Users/rotation/OneDrive/Tishkoff/scripts/closestGeneEnrichment.R
FILE=/Users/rotation/desktop/workspace/closest_gene_list.txt
AFR_DIR=$DIR/afr_summary_stats/closest_gene
EUR_DIR=$DIR/euro_summary_stats/closest_gene
OUTPUT=gene_enrich_stats_closest_gene

cd $DIR
touch $OUTPUT

while read -r a b
do
  echo "Processing $a and $b"
  echo $a $b >> $OUTPUT
  Rscript --vanilla $RSCRIPT $EUR_DIR/$a $AFR_DIR/$b >> $OUTPUT
done < $FILE
