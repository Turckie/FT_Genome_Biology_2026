#!/bin/bash
#SBATCH -p normal
#SBATCH --cpus-per-task=8

#define paths
working_directory=$(pwd)
#path_alignments=${working_directory}/STAR
path_alignments=${working_directory}/STAR
path_peaks=${working_directory}/Peaks/diffMACS3

#make result directory
mkdir -p ${path_peaks}

#tail -n +2 samples.txt | while read bamfile Sample name
 #do
 #conditions used by Duoan
 #macs3 callpeak -B -t ${path_alignments}/${bamfile} -n ${name}_${Sample}_call_summits_q0.02 --outdir ${path_peaks} \
 #-f BAM -q 0.02 -g 119667750 -s 55 --min-length 55 --max-gap 55 --extsize 55 --nomodel --keep-dup all \
 #--buffer-size 100000 --call-summits
 #done

macs3 bdgdiff --t1 ${path_peaks}/WT_2_Col-0_R2_call_summits_q0.02_treat_pileup.bdg --c1 ${path_peaks}/WT_2_Col-0_R2_call_summits_q0.02_control_lambda.bdg --t2 ${path_peaks}/e16_R2_5-25_R2_call_summits_q0.02_treat_pileup.bdg --c2 ${path_peaks}/e16_R2_5-25_R2_call_summits_q0.02_control_lambda.bdg \
--depth1 193980642 --depth2 143531941 --min-len 55 --max-gap 55 --cutoff 1 \
--outdir ${path_peaks} --o-prefix WT_vs_e16

macs3 bdgdiff --t1 ${path_peaks}/WT_2_Col-0_R2_call_summits_q0.02_treat_pileup.bdg --c1 ${path_peaks}/WT_2_Col-0_R2_call_summits_q0.02_control_lambda.bdg --t2 ${path_peaks}/e14_R2_6-70_R2_call_summits_q0.02_treat_pileup.bdg --c2 ${path_peaks}/e14_R2_6-70_R2_call_summits_q0.02_control_lambda.bdg \
--depth1 193980642 --depth2 197509846 --min-len 55 --max-gap 55 --cutoff 1 \
--outdir ${path_peaks} --o-prefix WT_vs_e14

macs3 bdgdiff --t1 ${path_peaks}/WT_2_Col-0_R2_call_summits_q0.02_treat_pileup.bdg --c1 ${path_peaks}/WT_2_Col-0_R2_call_summits_q0.02_control_lambda.bdg --t2 ${path_peaks}/e12_R2_9-42_R2_call_summits_q0.02_treat_pileup.bdg --c2 ${path_peaks}/e12_R2_9-42_R2_call_summits_q0.02_control_lambda.bdg \
--depth1 193980642 --depth2 225154102 --min-len 55 --max-gap 55 --cutoff 1 \
--outdir ${path_peaks} --o-prefix WT_vs_e12

macs3 bdgdiff --t1 ${path_peaks}/WT_1_Col-0_R1_call_summits_q0.02_treat_pileup.bdg --c1 ${path_peaks}/WT_1_Col-0_R1_call_summits_q0.02_control_lambda.bdg --t2 ${path_peaks}/e16_R1_5-25_R1_call_summits_q0.02_treat_pileup.bdg --c2 ${path_peaks}/e16_R1_5-25_R1_call_summits_q0.02_control_lambda.bdg \
--depth1 66808980  --depth2 67479202 --min-len 55 --max-gap 55 --cutoff 1 \
--outdir ${path_peaks} --o-prefix WT_vs_e16_R1

macs3 bdgdiff --t1 ${path_peaks}/WT_2_Col-0_R2_call_summits_q0.02_treat_pileup.bdg --c1 ${path_peaks}/WT_2_Col-0_R2_call_summits_q0.02_control_lambda.bdg --t2 ${path_peaks}/e14_R1_6-70_R1_call_summits_q0.02_treat_pileup.bdg --c2 ${path_peaks}/e14_R1_6-70_R1_call_summits_q0.02_control_lambda.bdg \
--depth1 193980642 --depth2 151982350  --min-len 55 --max-gap 55 --cutoff 1 \
--outdir ${path_peaks} --o-prefix WT_vs_e14_R1

macs3 bdgdiff --t1 ${path_peaks}/WT_2_Col-0_R2_call_summits_q0.02_treat_pileup.bdg --c1 ${path_peaks}/WT_2_Col-0_R2_call_summits_q0.02_control_lambda.bdg --t2 ${path_peaks}/e12_R1_9-42_R1_call_summits_q0.02_treat_pileup.bdg --c2 ${path_peaks}/e12_R1_9-42_R1_call_summits_q0.02_control_lambda.bdg \
--depth1 193980642 --depth2 181088147 --min-len 55 --max-gap 55 --cutoff 1 \
--outdir ${path_peaks} --o-prefix WT_vs_e12_R1

