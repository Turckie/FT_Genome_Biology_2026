#!/bin/bash
#SBATCH -p normal
#SBATCH --cpus-per-task=2


working_directory=$(pwd)
path_merged=${working_directory}/results/IDR/s45

cd ${path_merged}



cat e12_R1_9-42_R1.bed e14_R1_6-70_R1.bed e16_R1_5-25_R1.bed WT_R1_Col-0_R1.bed  \
    | bedtools sort -i - \
    | bedtools merge -i - \
    > merged_all.bed
bedtools intersect -a merged_all.bed -b e12_R1_9-42_R1.bed -c > tmp1.bed
bedtools intersect -a tmp1.bed       -b e14_R1_6-70_R1.bed -c > tmp2.bed
bedtools intersect -a tmp2.bed       -b e16_R1_5-25_R1.bed -c > tmp3.bed
bedtools intersect -a tmp3.bed       -b WT_R1_Col-0_R1.bed -c > merged_counts.bed

awk 'BEGIN {OFS=FS="\t"} ($4+$5+$6+$7 >= 2) {print $1,$2,$3,$4"_"$5"_"$6"_"$7 }' merged_counts.bed \
    > ${working_directory}/Peaks/MACS3/s45/Master_merged_min2.bed
cd -
