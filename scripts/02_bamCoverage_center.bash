#!/bin/bash
#SBATCH -p normal
#SBATCH --cpus-per-task=8

#define paths
working_directory=$(pwd)
path_reads=${working_directory}/data/STAR
path_coverage=${working_directory}/results/coverage
path_alignments=${working_directory}/results/alignments

#make result directory
mkdir -p ${path_coverage}
mkdir -p ${path_alignments}


tail -n +2 samples.txt | while read bamfile Sample name
do
bedtools bamtobed -i ${path_reads}/$bamfile \
| awk '{mid=int(($2+$3)/2); print $1"\t"mid"\t"mid+1"\t"$4"\t"$5"\t"$6}' \
| bedtools bedtobam -i - -g TAIR10.chrlength_all.txt | samtools sort - > ${path_alignments}/${Sample}.midpoint.bam
  samtools index ${path_alignments}/${Sample}.midpoint.bam
bamCoverage -b ${path_alignments}/${Sample}.midpoint.bam -o ${path_coverage}/${name}_midpoint.bw \
            --binSize 1 --region Chr1:24310000:24360000 \
            -p max/2
done

