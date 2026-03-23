#!/bin/bash
working_directory=$(pwd)

cd results/alignments

echo -e "file"'\t'"category"'\t'"number" > $working_directory/results/alignment_metrics/Mapping.info.txt

for i in *.bam
do
samtools view -c ${i} > tmp
echo -e "${i}"'\t'"all_reads" >tmp2 
paste tmp2 tmp >>$working_directory/results/alignment_metrics/Mapping.info.txt
samtools view -c -F 260 ${i} > tmp
echo -e "${i}"'\t'"mapped_reads" >tmp2 
paste tmp2 tmp >>$working_directory/results/alignment_metrics/Mapping.info.txt
samtools view -c -q 10 ${i} >tmp
echo -e "${i}"'\t'"uniquely_mapped_reads" >tmp2
paste tmp2 tmp >>$working_directory/results/alignment_metrics/Mapping.info.txt
rm tmp tmp2
done
cd $working_directory
