#!/bin/bash

working_directory=$(pwd)
path_peaks=${working_directory}/results/Peaks/MACS3
cd ${path_peaks}

#filter the aligned reads to keep only uniquely aligned reads

#cat e12_R1_9-42_R1_call_summits_q0.02_peaks.narrowPeak \
#    e12_R2_9-42_R2_call_summits_q0.02_peaks.narrowPeak \
#    e14_R1_6-70_R1_call_summits_q0.02_peaks.narrowPeak \
#    e14_R2_6-70_R2_call_summits_q0.02_peaks.narrowPeak \
#    e14_R1_6-70_R1_call_summits_q0.02_peaks.narrowPeak \
#    e14_R2_6-70_R2_call_summits_q0.02_peaks.narrowPeak \
#    WT_1_Col-0_R1_call_summits_q0.02_peaks.narrowPeak \
#    WT_2_Col-0_R2_call_summits_q0.02_peaks.narrowPeak | \
#    bedtools sort -i - | \
#    bedtools merge -i - > Master_peaks_call_summits_q0.02.bed


cat e12_R1_9-42_R1_s45_q0.02_peaks.narrowPeak \
    e12_R2_9-42_R2_s45_q0.02_peaks.narrowPeak \
    e14_R1_6-70_R1_s45_q0.02_peaks.narrowPeak \
    e14_R2_6-70_R2_s45_q0.02_peaks.narrowPeak \
    e14_R1_6-70_R1_s45_q0.02_peaks.narrowPeak \
    e14_R2_6-70_R2_s45_q0.02_peaks.narrowPeak \
    WT_1_Col-0_R1_s45_q0.02_peaks.narrowPeak \
    WT_2_Col-0_R2_s45_q0.02_peaks.narrowPeak | \
    bedtools sort -i - | \
    bedtools merge -i - > Master_peaks_s45_q0.02.bed
cd ${working_directory}
