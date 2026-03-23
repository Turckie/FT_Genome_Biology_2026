#!/bin/bash

project_directory=$(pwd)
working_directory=$(pwd)
path_alignments=${working_directory}/results/alignments
path_alignments_unique=${working_directory}/results/alignments/unique
path_results=${project_directory}/results/Insert_sizes
######################################################################################################################
mkdir -p ${path_results}

cd ${path_alignments_unique}
for i in Col-0_R1 Col-0_R2 FTG38_3-37_R1 FTG38_3-37_R2
do
picard CollectInsertSizeMetrics -I ${i}.uniq.bam -O ${path_results}/${i}.uniq_fragdist_metrics.txt -H ${path_results}/${i}.uniq_1_fragdist_histo.pdf
done
cd ${project_directory}

