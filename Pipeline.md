---
title: "Haoran Zhou MOA-seq"
format: html
execute:
  eval: false
---

## Aim

The original MOAseq data was done by Duong Thi Hai Doan. We have received reviewer's comments for the genome biology submission and need to do some additional analyses.

### Here the relevant comments by the reviewer:

Reviewer 1:

The authors performed MOA-seq to analyze changes in transcription factor occupancy in the region in WT and three CRISPR/Cas9-induced deletion mutants. The results are shown in Figures 4d and S5.

-   The current figure shows only one magnification, so it is difficult to see whether there are differences in binding across other specific cis elements discussed in this manuscript. The results of this dataset are totally underutilized.

-   First, please provide a magnified data of the area around Block E and indicate the positions of the cis-elements discussed (CCAAT-box, G-box, PEB-box, RE-alpha, etc.).

-   Also, their previous work showed that the CCAAT-box in Block C is also important for FT transcription.

-   Also, would it be possible to compare the results of these peaks more quantitatively?

-   Second, since they conclude in this paper that the CCAAT-box in Block E is important, they should also show MOA-seq results for the entire FT regulatory regions in these mutants (in separate figures covering different regions).

-   Please show/analyze the MOA-seq results and discuss whether Block E mutations do or do not influence the binding of CCAAT-box binding factors in other known binding sites, like Block C, and also other transcription factors in other known enhancer regions and around the FT transcriptional start area.

-   It would be informative to have at least two scale versions (one covering a larger area, like the ones shown in Figures 4d and S5, and the others magnifying specific known enhancer regions) to see the results of their MOA-seq.

Haoran already prepared overview coverage tracks that include Block C and higher resolution tracks. He prepared positions files around the relevant CCAAT motifs we could try to quantify coverage at these motifs in comparison with control regions. We could also do peak detection and differential peak detection.

It may be interesting to analyze the fragment starts to visualize cutting sites rather than protected sites.

### Previous pipeline

I have limited documentation of the first analysis. The following is copy-pasted from the methods section of the manuscript:

Adapters were trimmed with SeqPurge \[52\] using default settings, ensuring a minimum read length of 20 bp. Paired-end reads were merged with FLASH \[53\]. Reads were aligned to the *A. thaliana* TAIR10 genome using STAR \[54\], with maximum permissible intron size restricted to 1 (--alignIntronMax 1) and multimapping tolerance set to 1 (--outFilterMultimapNmax), allowing only uniquely mapping reads. Alignments were converted to coordinate-sorted BAM files and coverage tracks generated with deepTools bamCoverage \[55\] using CPM normalization, 1-bp bins, maximum fragment length of 80 bp, and minimum mapping quality of 255. Coverage was visualized using IGV \[56\].

52.      Sturm M, Schroeder C, Bauer P. SeqPurge: highly-sensitive adapter trimming for paired-end NGS data. BMC Bioinformatics. 2016;17:208.

53.      Magoc T, Salzberg SL. FLASH: fast length adjustment of short reads to improve genome assemblies. Bioinformatics. 2011;27(21):2957-63.

54.      Dobin A, Davis CA, Schlesinger F, Drenkow J, Zaleski C, Jha S, et al. STAR: ultrafast universal RNA-seq aligner. Bioinformatics. 2013;29(1):15-21.

55.      Ramirez F, Dundar F, Diehl S, Gruning BA, Manke T. deepTools: a flexible platform for exploring deep-sequencing data. Nucleic Acids Res. 2014;42(Web Server issue):W187-91.

56.      Robinson JT, Thorvaldsdottir H, Winckler W, Guttman M, Lander ES, Getz G, et al. Integrative genomics viewer. Nat Biotechnol. 2011;29(1):24-6.

In general, the reads were not mapped as paired-end reads but after merging of short reads. I do not know if that means that longer reads a fully discarded (they may have been discarded before library preparation).

***The reference genome that was used for mapping had the "Chr" annotation, not chr***

## New analyses

I will create a micromamba environment for the analysis named "MOA".

`micromamba env create -n MOA -f MOA.yaml`

Details of installed packges:

`micromamba export -n MOA > MOA.yml`

## Prepare special coverage tracks using bamCoverage

Looking at the start of each read can provide information where protected areas locate with the peak regions.

First make a list of all mapped.bam files in the folder "STAR"

``` bash
ls STAR/*bam >samples.txt
```

Use editor to make this into a useful sample table:

| `bamfiles Sample  Name`
| `Ara-5-25Aligned.sortedByCoord.out.bam    5-25_R1 e16_R1`
| `Ara-5-25_R2Aligned.sortedByCoord.out.bam 5-25_R2 e16_R2`
| `Ara-6-70Aligned.sortedByCoord.out.bam    6-70_R1 e14_R1`
| `Ara-6-70_W31Aligned.sortedByCoord.out.bam    6-70_R2 e14_R2`
| `Ara-9-42Aligned.sortedByCoord.out.bam    9-42_R1 e12_R1`
| `Ara-9-42_W32Aligned.sortedByCoord.out.bam    9-42_R2 e12_R2`
| `Ara-Col0Aligned.sortedByCoord.out.bam    Col-0_R1    WT_1`
| `Ara-Col0_R2Aligned.sortedByCoord.out.bam Col-0_R2    WT_2`

Use the script called below to create files that just summarized the flanks or the center of each read. The operation is limited to the larger region surrounding FT

``` bash
sbatch scripts/01_bamCoverage.bash
```

The option center from bamCoverage did not just use the center point for coverage. The AI suggested solution was to convert the files to bed format and calculate the mid-point restricted file by hand.

``` bash
sbatch scripts/02_bamCoverage_center.bash
```

## Test how the result would look without FLASH

We seem to be losing information because of using FLASH. I want to test for both Col-0 samples if the results would look differently with a dovetailing paired end alignment.

``` bash
sbatch scripts/03_alignment.bash
```

Filter also uniquely mapped reads

``` bash
sbatch scripts/04_filter_alignments_unique.bash
```

``` bash
sbatch scripts/05_alignment_stats.bash
```

### Make coverage tracks

``` bash
sbatch scripts/01_bamCoverage.bash
```

## Make numerical coverage across FT regions

First generate a numerical coverage track in bedgraph format around the FT region. I bedgraph track uses the centered reads, the other the entire read. The bin size is 10.

``` bash
sbatch scripts/07_BedGraph_bamCoverage.bash
```

Plot a histogram of count values.

```{r}
library(ggplot2)
library(pscl)
data <- read.table("results/bedgraph/WT_2_10.bedgraph", header=F)
head(data)
x <- data$V4
zip_model <- zeroinfl(x ~ 1 | 1, dist = "poisson")
summary(zip_model)

lambda <- exp(coef(zip_model)$count)
p <- plogis(coef(zip_model)$zero)
lambda
p

pois_model <- glm(x ~ 1, family = poisson)
library(MASS)
nb_model <- glm.nb(x ~ 1)




```

``` bash
bedtools makewindows -b FT_region.bed -w 35 > data/FT_region_35w.bed
bedtools makewindows -b FT_region.bed -w 25 > data/FT_region_25w.bed
bedtools makewindows  -b FT_region.bed -w 10 > data/FT_region_10w.bed
```

## A more quantitative analysis of MOAseq data

I installed MACS3 and Genrich in the micromamba environment. All my settings with MAC3 using the paired end reads resulted in a limited number of peaks (less than those obtained using the bam for the original mappings from Douan. The Genrich solution had even less peaks, in the end, it is better to use the orginal mappings for this purpose.

``` r
samtools stat results/alignments/unique/WT_2.uniq.bam > tmp

macs3 callpeak -t results/alignments/unique/WT_2.uniq.bam -f BAM -n results/peaks/MACS3_WT_2 -g 119667750 --keep-dup all -q 0.1 -s 55 --min-length 55 --max-gap 55 --nomodel --extsize 55 --buffer-size 100000
```

``` bash
samtools sort -n results/alignments/unique/WT_2.uniq.bam -o results/alignments/unique/WT_2.uniqNsort.bam
Genrich -j -D -t results/alignments/unique/WT_2.uniqNsort.bam -o results/peaks/Genrich_WT_2 
```

Genrich was very conservative in predicting peaks, MACS3 in the ATAC-seq hhm did not work because the model wanted to find also dinucleosomes and mononucleosomes.

### Calling the peaks from the original mapping data with MACS3

I tried peak calling with several options, such as differences in minimal read length, stringency etc. In the end, the slightly longer minimal read length (55bp) may be the best solution, I used also call summits to break down larger peaks to subpeaks. Peaks at Blocks C and A were detected, at the promoter only some samples detected peaks. The deletions detected peaks as expected. In the relevant samples, the downstream of Block E peak was also detected.

I also run the script ones with less stringency so that the IDR analysis for keeping overlapping peaks would also work.

``` bash
sbatch scripts/08_MACS3_Peak_calling.bash
```

#### Retaining only peaks that are supported by two replicates

Retain only peaks present in both replicates using bedtools. If peaks overlap, keep R2, which did not show the artifact due to using two different sequencing companies.

-   **Try out IDR to retain replicates:**

IDR work better if there are also low quality peaks in the analysis. Thus peaks were predicted at FDR 0.5 and sent to folder Peaks/MACS3/Lowq_for_IDR

In micromamba environment TRB_Krause_et_al

``` bash
idr --samples Peaks/MACS3/LOwq_for_IDR/e16_R1_5-25_R1_call_summits_q0.9_peaks.narrowPeak Peaks/MACS3/LOwq_for_IDR/e16_R2_5-25_R2_call_summits_q0.9_peaks.narrowPeak --input-file-type narrowPeak --peak-merge-method max --output-file results/IDR/e16_5-25-IDR.pValueBL --plot

awk 'BEGIN{FS=OFS="\t"} ($5 >= 540) {print $0}' results/IDR/e16_5-25-IDR.pValueBL >results/IDR/e16_5-25-IDR.SigpValueBL
awk 'BEGIN{FS=OFS="\t"} {print $1,$2,$3,$5}' results/IDR/e16_5-25-IDR.SigpValueBL > Peaks/e16_5-25.bed
 
```

Run all of them with this script:

``` bash
sbatch scripts/08b_Peak_replicates_IDR.bash
```
Haoran has now already prepared figures using the s45 files. I moved them to a folder labeled s45. The master peak file should also be prepared with s45. I will try to do that with idr, but  using the --only-merge-peaks tag.

First step: merge duplicates using only peaks that are supported by both
Second step: merge all peaks, using every supported peak.

In the next step, I would like to keep a Master file that merges the 4 bedfiles, while keeping only fragments supported by at least 2 bedfiles. The script below did the opposite, it kept only intersections.

``` bash
working_directory=$(pwd)
path_merged=${working_directory}/results/IDR/s45

cd ${path_merged}

for i in *bed
do
bedtools sort -i ${i} > sorted_${i}
done


bedtools multiinter -cluster -i sorted_e12_R1_9-42_R1.bed sorted_e14_R1_6-70_R1.bed sorted_e16_R1_5-25_R1.bed sorted_WT_R1_Col-0_R1.bed \
    | awk '$4 >= 2' \
    > ${working_directory}/Peaks/MACS3/s45/s45_intersections_min2.bed
cd -
```
See below for a more complicates script that keeps only merged peaks supported by at least 2 predictions.

### Differential peak calling with MACS3

For differential peak calling I had to generate bedgraph tracks and needed the total number of mapped fragments for normalization. To get this number out of the slurm-output I used the lines below.

Again, here I tried different parameters and differential peaks were detected more or less as expected. Replicate 1 WT was only used to detect peaks for e16, as these two were sequenced at a different company and somehow deviate in shape.

``` bash
sbatch scripts/09_MACS3_diffPeak_calling.bash
```

``` bash
grep 'Write bedGraph files for treatment pileup (after scaling if necessary)...'  slurm-644916.out >tmp
grep '#1  total tags in treatment:' slurm-644916.out >tmp2
paste tmp tmp2 > Peaks/diffMACS3/tagnumbers.txt
```

#### Merge all predicted peaks

The aim is to get a masterfile with all predicted peaks, determine the coverage for these peaks, generate a count matrix and use DESeq2 for differential analysis.

``` bash
sbatch scripts/10_master_peak_files.bash
```


The follwing script creates a master file from IDR merged replicates, but only if at least two samples predicted the peak.

``` bash
sbatch scripts/10_master_peak_files.bash
```


``` bash
sbatch scripts/10b_master_peak_files_with_supportby2.bash
```


Maybe it is o.k. to just process Chromosome 1, saves time as there are many peaks...

``` bash
grep Chr1 Peaks/MACS3/s45/Master_merged_min2.bed > Peaks/MACS3/s45/Chr1_Master_merged_min2.bed

#grep Chr1 Peaks/MACS3/Master_peaks_s45_q0.02.bed > Peaks/MACS3/Chr1_Master_peaks_s45_q02.02.bed
```

After merging, both master tables are basically identical

#### Split merged peaks into smaller subunits

Create a bed file with 35bp windows across chromosome1, use the peak file to select windows that overlap. Calculate coverage over windows and create a matrix for DEseq2.

``` bash
bedtools makewindows -g TAIR10.chrlength_all.txt -w 35 > data/TAIR10_35_bp.bed
bedtools makewindows -g TAIR10.chrlength_all.txt -w 45 > data/TAIR10_45_bp.bed
bedtools makewindows -g TAIR10.chrlength_all.txt -w 55 > data/TAIR10_55_bp.bed
bedtools makewindows -g TAIR10.chrlength_all.txt -w 100 > data/TAIR10_100_bp.bed
```

Use bedtools intersect to select all windows overlapping with the Chr1 masterfile for enriched regions.

``` bash
bedtools intersect -a data/TAIR10_100_bp.bed -b Peaks/MACS3/Chr1_Master_peaks_call_summits_q0.02.bed > Peaks/MACS3/Chr1_in_100bp_Master_peaks_call_summits_q0.02.bed
```

#### Make a coverage matrix using bedtools

``` bash
sbatch scripts/11_coverage_matrix.bash
```

#### Combine the first three columns of the coverage matrix to a name

``` bash
awk 'BEGIN {OFS=FS="\t"} {print $1"_"$2"_"$3, $4,$5,$6,$7,$8,$9,$10,$11}' results/countmatrix/Chr1_countMatrix.txt | \
sed -i '1iID\te16_R1\te16_R2\te14_R1\te14_R2\te12_R1\te12_R2\tWT_R1\tWT_R2' > results/countmatrix/Chr1_countMatrix_for_import.txt

awk 'BEGIN {OFS=FS="\t"} {print $1"_"$2"_"$3, $4,$5,$6,$7,$8,$9,$10,$11}' results/countmatrix/Chr1_in_45bp_countMatrix.txt | \
sed '1iID\te16_R1\te16_R2\te14_R1\te14_R2\te12_R1\te12_R2\tWT_R1\tWT_R2' > results/countmatrix/Chr1_in_45bp_countMatrix_for_import.txt

awk 'BEGIN {OFS=FS="\t"} {print $1"_"$2"_"$3, $4,$5,$6,$7,$8,$9,$10,$11}' results/countmatrix/Chr1_in_55bp_countMatrix.txt | \
sed '1iID\te16_R1\te16_R2\te14_R1\te14_R2\te12_R1\te12_R2\tWT_R1\tWT_R2' > results/countmatrix/Chr1_in_55bp_countMatrix_for_import.txt

awk 'BEGIN {OFS=FS="\t"} {print $1"_"$2"_"$3, $4,$5,$6,$7,$8,$9,$10,$11}' results/countmatrix/Chr1_in_100bp_countMatrix.txt | \
sed '1iID\te16_R1\te16_R2\te14_R1\te14_R2\te12_R1\te12_R2\tWT_R1\tWT_R2' > results/countmatrix/Chr1_in_100bp_countMatrix_for_import.txt


awk 'BEGIN {OFS=FS="\t"} {print $1"_"$2"_"$3, $4,$5,$6,$7,$8,$9,$10,$11}' results/countmatrix/Chr1_in_100bp_countMatrix.txt | \
sed '1iID\te16_R1\te16_R2\te14_R1\te14_R2\te12_R1\te12_R2\tWT_R1\tWT_R2' > results/countmatrix/Chr1_in_100bp_countMatrix_for_import.txt

```

### Statistical analysis with DESeq2

Using the master peak list from chromosome 1 only showed differences across e12 Block E regions. The increased peak after BlockE was not detected as significant.

I tried to cut down the peaks to smaller subunits, but that resulted in less significance. In contrast, the p-values were significant =\> more fragments tested = multiple testing correction gets more stringend

``` bash
bedtools intersect -a Peaks/MACS3/Chr1_Master_peaks_call_summits_q0.02.bed -b data/FT_region.bed > Peaks/MACS3/Peaks_around_FT.bed

awk 'BEGIN {OFS=FS="\t"} {print $1"_"$2"_"$3}' Peaks/MACS3/Peaks_around_FT.bed > results/countmatrix/FT_peaks.txt
```