#!/bin/sh
#bcftools index all files in a folder

DIR=/Users/rotation/downloads/1kgenomes/brit/traits/1
EXTENSION=vcf.gz

cd $DIR
for f in ${DIR}/*.${EXTENSION}
do
  echo "Processing ${f##*/}..."
  bcftools index $f
done
