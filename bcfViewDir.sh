#!/bin/sh
#bcftools view all vcf files in folder

DIR=/Users/rotation/downloads/1kgenomes
EXTENSION=vcf.gz
SAMPLES=/Users/rotation/desktop/GBR_sample_names.txt
OUTPUT_DIR=$DIR/brit

cd $DIR
for f in ${DIR}/*.${EXTENSION}
do
  echo "Processing ${f##*/}..."
  bcftools view -S $SAMPLES --force-samples -O z -o $OUTPUT_DIR/brit_${f##*/} $f
done
