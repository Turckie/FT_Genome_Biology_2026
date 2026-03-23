# FT_Genome_Biology_2026
Scripts used for MOAseq analysis published in  \[comment: insert final link\] **Cis-regulatory architecture downstream of *FLOWERING LOCUS T* underlies quantitative control of flowering in *Arabidopsis thaliana*** *by* Hao-Ran Zhou (周豪然), Duong Thi Hai Doan, Thomas Hartwig and Franziska Turck, published in Genome Biology (2026).
# Introduction

**Abstract**

**Background:** The *FLOWERING LOCUS T* (*FT*) gene is a central integrator of floral induction in *Arabidopsis thaliana*, with its precise expression controlled by complex transcriptional networks. While upstream regulatory regions are well-studied, the role of downstream *cis*-regulatory elements in modulating *FT* expression remains poorly characterized.

**Results:** Systematic dissection of the *FT* downstream region in its native chromosomal context using CRISPR/Cas9-mediated genome editing provides genetic evidence that a 2.3-kb sequence, encompassing the Block E enhancer immediately adjacent to the *FT* coding sequence, is essential for proper *FT* expression and timely flowering. Fine-scale deletions within Block E reveal that a 63-bp sequence containing one CCAAT-box and one G-box, both closely spaced, forms a core functional module, whereas other conserved motifs contribute modestly in a context-dependent manner. Strikingly, a cryptic CCAAT-box module downstream of Block E that becomes active when repositioned. This coincides with increased transcription factor occupancy and local chromatin accessibility.

**Conclusions:** Our work reveals that quantitative *FT* expression and flowering time are governed by the spatial organization and chromatin context of downstream *cis*-regulatory elements. The positional sensitivity and modular logic of these elements provide framework for understanding and engineering quantitative gene regulation through targeted cis-regulatory design, a concept broadly applicable across diverse developmental systems.

**Keywords:** *FLOWERING LOCUS T* (*FT*), *cis*-regulatory elements, downstream enhancer, CCAAT-box, CRISPR/Cas9, flowering time regulation, *Arabidopsis thaliana*

## Structure of this repository

Two quarto files in the top folder **`Pipeline.qmd:`** and **`DESeq-Analysis.qmd`**.

**`Pipeline.qmd:`** describes Linux commands to run scripts that download raw read data, align them to the Arabidopsis thaliana TAIR10 genome and generate peak predictions, coverage tracks etc. The actual scripts are placed in the folder **`scripts`**. The pipline also includes some analyses that did not end up in the manuscript, such as MOAseq differential peak analysis with MACS3. **`DESeq-Analysis.qmd`** contains commented R commands that were used to take a coverage file from Chr1 and perform a differential peak analysis with DESeq2.

The raw MOAseq reads are deposited in the European Nucleotide Archive (ENA) under the accession PRJEB97763. To recapitulate the entire pipeline, the sequence reads can be downloaded from there. 

Intermediate results required for the analysis (such as the Chr1 coverage tracks) can be downloaded from the following Zenodo repository: 
