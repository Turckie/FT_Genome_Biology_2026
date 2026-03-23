#!/bin/bash

working_directory=$(pwd)
mkdir -p results/alignments/unique
cd results/alignments

#filter the aligned reads to keep only uniquely aligned reads

for i in WT*.bam
do
samtools view -q 10 -b ${i} > unique/${i%.bam}.uniq.bam
samtools index unique/${i%.bam}.uniq.bam
done
cd $working_directory
