#!/bin/bash
#SBATCH -p normal
#SBATCH --cpus-per-task=8

#define paths
working_directory=$(pwd)
#path_alignments=${working_directory}/STAR
path_alignments=${working_directory}/STAR
path_peaks=${working_directory}/Peaks/MACS3/LOwq_for_IDR

#make result directory
mkdir -p ${path_peaks}

tail -n +2 samples.txt | while read bamfile Sample name
do
#conditions used by Duoan
#macs3 callpeak -t ${path_alignments}/${bamfile} -n ${name}_${Sample}_q0.02 --outdir ${path_peaks} \
#-f BAM -q 0.02 -g 119667750 -s 55 --min-length 55 --max-gap 55 --nomodel --extsize 55 --keep-dup all \
#--buffer-size 100000

#less extension 
#macs3 callpeak -t ${path_alignments}/${bamfile} -n ${name}_${Sample}_noext_q0.02 --outdir ${path_peaks} \
#-f BAM -q 0.02 -g 119667750 -s 55 --min-length 55 --max-gap 55 --nomodel --keep-dup all \
#--buffer-size 100000

#smaller minimum less extension
#macs3 callpeak -t ${path_alignments}/${bamfile} -n ${name}_${Sample}_noext_smallerreads_q0.02 --outdir ${path_peaks} \
#-f BAM -q 0.02 -g 119667750 -s 45 --min-length 45 --max-gap 45 --extsize 45 --nomodel --keep-dup all \
#--buffer-size 100000

#smaller minimum
#macs3 callpeak -t ${path_alignments}/${bamfile} -n ${name}_${Sample}_s45_q0.02 --outdir ${path_peaks} \
#-f BAM -q 0.02 -g 119667750 -s 45 --min-length 45 --max-gap 45 --extsize 45 --nomodel --keep-dup all \
#--buffer-size 100000

#peak-summits
macs3 callpeak -t ${path_alignments}/${bamfile} -n ${name}_${Sample}_call_summits_q0.9 --outdir ${path_peaks} \
-f BAM -q 0.9 -g 119667750 -s 55 --min-length 55 --max-gap 55 --extsize 55 --nomodel --keep-dup all \
--buffer-size 100000 --call-summits
done
