#!/bin/bash

path_reads=/biodata/dep_coupland/grp_turck/NGS_data_GC/Haoran_Col0_FT-CRISPR/raw_data/submission
mkdir -p results/alignments/unique
mkdir -p results/alignment_metrics



tail -n +8 samples.txt | while read bamfile Sample name
do
 bwa-mem2 mem TAIR10_Chr ${path_reads}/${Sample}_Lall_1.fq.gz ${path_reads}/${Sample}_Lall_2.fq.gz | samtools view -b - | samtools sort - -o results/alignments/${name}.bam
 samtools index results/alignments/${name}.bam
done

