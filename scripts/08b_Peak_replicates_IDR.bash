#!/bin/bash
#SBATCH -p normal
#SBATCH --cpus-per-task=8

#define paths
working_directory=$(pwd)
#path_peaks=${working_directory}/results/Peaks/MACS3/LOwq_for_IDR
path_peaks=${working_directory}/results/Peaks/MACS3/s45
path_results=${working_directory}/results/IDR/s45

mkdir -p ${path_results}

#for i in e12 e14 e16 WT
#or i in WT
#do
#    idr --samples \
#        "${path_peaks}/${i}_1_*_call_summits_q0.9_peaks.narrowPeak" \
#        "${path_peaks}/${i}_2_*_call_summits_q0.9_peaks.narrowPeak" \
#        --input-file-type narrowPeak \
#        --peak-merge-method max \
#        --output-file "${path_results}/${i}-IDR.pValueBL" \
#        --plot

#    awk 'BEGIN{FS=OFS="\t"} ($5 >= 540) {print $0}' "${path_results}/${i}-IDR.pValueBL" \
#        > "${path_results}/${i}-IDR.SigpValueBL"

#    awk 'BEGIN{FS=OFS="\t"} {print $1,$2,$3,$5}' "${path_results}/${i}-IDR.SigpValueBL" \
#        > Peaks/${i}.bed
#
#done


R1=(e12_R1_9-42_R1 e14_R1_6-70_R1 e16_R1_5-25_R1 WT_R1_Col-0_R1)
R2=(e12_R2_9-42_R2 e14_R2_6-70_R2 e16_R2_5-25_R2 WT_R2_Col-0_R2)

for idx in ${!R1[@]}
do
    i=${R1[$idx]}
    a=${R2[$idx]}

    idr --samples \
        "${path_peaks}/${i}_s45_q0.02_peaks.narrowPeak" \
        "${path_peaks}/${a}_s45_q0.02_peaks.narrowPeak" \
        --input-file-type narrowPeak \
        --peak-merge-method min \
        --only-merge-peaks \
        --output-file "${path_results}/${i}-merged"

    awk 'BEGIN{FS=OFS="\t"} {print $1,$2,$3,$5}' \
        "${path_results}/${i}-merged" \
        > "${path_results}/${i}.bed"

done

