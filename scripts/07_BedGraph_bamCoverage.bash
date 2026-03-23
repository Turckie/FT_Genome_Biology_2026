#!/bin/bash
#SBATCH -p normal
#SBATCH --cpus-per-task=8

#define paths
working_directory=$(pwd)
#path_alignments=${working_directory}/STAR
path_alignments=${working_directory}/results/alignments/unique
path_bedgraph=${working_directory}/results/bedgraph

#make result directory
mkdir -p ${path_bedgraph}

tail -n +8 samples.txt | while read bamfile Sample name
do
#bamCoverage -b ${path_alignments}/${name}.uniq.bam -o ${path_coverage}/${name}_1bp.bw \
#            --Offset 1 2 -bs 1 --region Chr1:24310000:24360000 \
#           -p max/2
#bamCoverage -b ${path_alignments}/${name}.uniq.bam -o ${path_coverage}/${name}_center.bw \
#           --centerReads -bs 1 --region Chr1:24310000:24360000 \
#           -p max/2
bamCoverage -b ${path_alignments}/${name}.uniq.bam -o ${path_bedgraph}/${name}_c10.bedgraph \
            --centerReads -bs 10 --smoothLength 9 --region Chr1:24310000:24360000 \
            -p max/2 -of bedgraph
bamCoverage -b ${path_alignments}/${name}.uniq.bam -o ${path_bedgraph}/${name}_10.bedgraph \
            -bs 10 --smoothLength 9 --region Chr1:24310000:24360000 \
            -p max/2 -of bedgraph
done
