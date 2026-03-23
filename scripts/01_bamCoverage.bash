#!/bin/bash
#SBATCH -p normal
#SBATCH --cpus-per-task=8

#define paths
working_directory=$(pwd)
#path_alignments=${working_directory}/STAR
path_alignments=${working_directory}/results/alignments/unique
path_coverage=${working_directory}/results/coverage

#make result directory
mkdir -p ${path_coverage}

tail -n +8 samples.txt | while read bamfile Sample name
do
#bamCoverage -b ${path_alignments}/${name}.uniq.bam -o ${path_coverage}/${name}_1bp.bw \
            --Offset 1 2 -bs 1 --region Chr1:24310000:24360000 \
            -p max/2
#bamCoverage -b ${path_alignments}/${name}.uniq.bam -o ${path_coverage}/${name}_center.bw \
            --centerReads -bs 1 --region Chr1:24310000:24360000 \
            -p max/2
bamCoverage -b ${path_alignments}/${name}.uniq.bam -o ${path_coverage}/${name}.bw \
            --centerReads -bs 3 --smoothLength 9 --region Chr1:24310000:24360000 \
            -p max/2
done
