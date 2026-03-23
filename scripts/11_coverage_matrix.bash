#!/bin/bash
#SBATCH -p normal
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=10G

working_directory=$(pwd)
path_peaks=${working_directory}/Peaks/MACS3
path_alignments=${working_directory}/STAR
path_countmatrix=${working_directory}/results/countmatrix
mkdir ${path_countmatrix}


#bedtools multicov -D -bams ${path_alignments}/Ara-5-25Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-5-25_R2Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-6-70Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-6-70_W31Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-9-42Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-9-42_W32Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-Col0Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-Col0_R2Aligned.sortedByCoord.out.bam \
#     -bed ${path_peaks}/Chr1_Master_peaks_call_summits_q0.02.bed > ${path_countmatrix}/Chr1_countMatrix.txt

#bedtools multicov -D -bams ${path_alignments}/Ara-5-25Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-5-25_R2Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-6-70Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-6-70_W31Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-9-42Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-9-42_W32Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-Col0Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-Col0_R2Aligned.sortedByCoord.out.bam \
#     -bed ${path_peaks}/Chr1_in_45bp_Master_peaks_call_summits_q0.02.bed > ${path_countmatrix}/Chr1_in_45bp_countMatrix.txt

#bedtools multicov -D -bams ${path_alignments}/Ara-5-25Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-5-25_R2Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-6-70Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-6-70_W31Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-9-42Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-9-42_W32Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-Col0Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-Col0_R2Aligned.sortedByCoord.out.bam \
#     -bed ${path_peaks}/Chr1_in_55bp_Master_peaks_call_summits_q0.02.bed > ${path_countmatrix}/Chr1_in_55bp_countMatrix.txt

#bedtools multicov -D -bams ${path_alignments}/Ara-5-25Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-5-25_R2Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-6-70Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-6-70_W31Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-9-42Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-9-42_W32Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-Col0Aligned.sortedByCoord.out.bam \
#     ${path_alignments}/Ara-Col0_R2Aligned.sortedByCoord.out.bam \
#     -bed ${path_peaks}/Chr1_in_100bp_Master_peaks_call_summits_q0.02.bed > ${path_countmatrix}/Chr1_in_100bp_countMatrix.txt

bedtools multicov -D -bams ${path_alignments}/Ara-5-25Aligned.sortedByCoord.out.bam \
     ${path_alignments}/Ara-5-25_R2Aligned.sortedByCoord.out.bam \
     ${path_alignments}/Ara-6-70Aligned.sortedByCoord.out.bam \
     ${path_alignments}/Ara-6-70_W31Aligned.sortedByCoord.out.bam \
     ${path_alignments}/Ara-9-42Aligned.sortedByCoord.out.bam \
     ${path_alignments}/Ara-9-42_W32Aligned.sortedByCoord.out.bam \
     ${path_alignments}/Ara-Col0Aligned.sortedByCoord.out.bam \
     ${path_alignments}/Ara-Col0_R2Aligned.sortedByCoord.out.bam \
     -bed ${path_peaks}/s45/Chr1_Master_merged_min2.bed > ${path_countmatrix}/Chr1_Master_merged_min2_countMatrix.txt
