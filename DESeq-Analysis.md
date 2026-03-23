---
title: "DESeq-analysis ChIP peaks"
format: html
editor: visual
---

## Libraries

Load the required libraries. Some libraries are loaded when required for plotting.

```{r}
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install()
#BiocManager::install("ideal")
library(DESeq2)
#library(ideal)
```

## Load count matrix

The count matrix was generated a raw reads from 8 MOA-seq libraries for all fragments of the "Master-list" of MOA-seq enriched regions. Enriched regions were detected by MACS3. Regions commonly detected in two replicates per genotype had been merged using the merge tool from the encode tool idr. The merged lists from 4 genotypes were merged using bedtools and compared to the genotype fragments. Fragments that were detected in at least two genotypes were kept in the master list. Data for Chromosome 1 were extracted and coverage as raw reads bad determined using bedtool coverage.

```{r}
counts <- read.table("results/countmatrix/Chr1_Master_merged_min2_countMatrix_for_import.txt", header=T, row.names=1,sep="\t")

#counts2 <- read.table("results/countmatrix/Chr1_in_100bp_countMatrix_for_import.txt", header=T, row.names=1,sep="\t")
```

Load Sample to genotype table.

```{r}
coldata <- read.table("results/countmatrix/samples.txt", header=T, sep="\t")
```

```{r}
head(counts)
head(coldata)
```

## DESeq Analysis

Create a dds object by combining countmatrix and sample table. Genotypes are compared to WT as reference.

```{r}
dds <- DESeqDataSetFromMatrix(
    countData = counts,
    colData   = coldata,
    design    = ~ genotype
)

#dds2 <- DESeqDataSetFromMatrix(
#    countData = counts2,
#    colData   = coldata,
#    design    = ~ genotype
#)


dds$genotype <- relevel(dds$genotype, ref = "WT")
#dds2$genotype <- relevel(dds2$genotype, ref = "WT")
```

This performs the statistical analysis and produces normalized count data.

```{r}
dds <- DESeq(dds)
#dds2 <- DESeq(dds2)
```

```{r}
resultsNames(dds)
#resultsNames(dds2)
```

Extract the results from each analysis

```{r}
res_e12_vs_WT <- results(dds, name="genotype_e12_vs_WT")
res_e14_vs_WT <- results(dds, name="genotype_e14_vs_WT")
res_e16_vs_WT <- results(dds, name="genotype_e16_vs_WT")

#res2_e12_vs_WT <- results(dds2, name="genotype_e12_vs_WT")
#res2_e14_vs_WT <- results(dds2, name="genotype_e14_vs_WT")
#res2_e16_vs_WT <- results(dds2, name="genotype_e16_vs_WT")

#resOrdered <- res_e12_vs_WT[order(res_e12_vs_WT$pvalue),]

```

Extract the significant results from each comparison

```{r}

sig_e12_vs_WT <-subset(res_e12_vs_WT, padj < 0.05)
sig_e14_vs_WT <-subset(res_e14_vs_WT, padj < 0.05)
sig_e16_vs_WT <-subset(res_e16_vs_WT, padj < 0.05)

#sig2_e12_vs_WT <-subset(res2_e12_vs_WT, pvalue < 0.05)
#sig2_e14_vs_WT <-subset(res2_e14_vs_WT, pvalue < 0.05)
#sig2_e16_vs_WT <-subset(res2_e16_vs_WT, pvalue < 0.05)


```

```{r}
library(dplyr)
library(tibble)

tidy_res <- function(res, comparison_name) {
  res %>%
    as.data.frame() %>%
    rownames_to_column("peak") %>%
    mutate(comparison = comparison_name)
}

e12_vs_WT <- tidy_res(sig_e12_vs_WT, "e12_vs_WT")
e14_vs_WT <- tidy_res(sig_e14_vs_WT, "e14_vs_WT")
e16_vs_WT <- tidy_res(sig_e16_vs_WT, "e16_vs_WT")

combined_sig <- bind_rows(e12_vs_WT, e14_vs_WT, e16_vs_WT)

library(tidyr)

 wide_table<- combined_sig %>%
  select(peak, comparison, baseMean, log2FoldChange, lfcSE, stat, pvalue,padj) %>%
  pivot_wider(names_from = comparison, values_from = log2FoldChange)


```

```{r}
library(knitr)
library(kableExtra)

 combined_sig %>%
  kable(format = "html", digits = 3, caption = "DESeq2 Significant Genes") %>%
  kable_styling(full_width = FALSE, bootstrap_options = c("striped", "hover"))

```

```{r}
library(openxlsx)


wb <- createWorkbook()

addWorksheet(wb, sheet = "res_e12_vs_WT", gridLines = TRUE)
addWorksheet(wb, sheet = "res_e14_vs_WT", gridLines = TRUE)
addWorksheet(wb, sheet = "res_e16_vs_WT", gridLines = TRUE)
addWorksheet(wb, sheet = "combined_sig", gridLines = TRUE)
addWorksheet(wb, sheet = "countmatrix", gridLines = TRUE)


writeData(wb, sheet = "combined_sig", x = as.matrix(combined_sig), rowNames = TRUE, withFilter = TRUE)
writeData(wb, sheet = "res_e12_vs_WT", x = as.matrix(res_e12_vs_WT), rowNames = TRUE, withFilter = TRUE)
writeData(wb, sheet = "res_e14_vs_WT", x = as.matrix(res_e14_vs_WT), rowNames = TRUE, withFilter = TRUE)
writeData(wb, sheet = "res_e16_vs_WT", x = as.matrix(res_e16_vs_WT), rowNames =TRUE, withFilter = TRUE)
writeData(wb, sheet = "countmatrix", x = counts(dds), rowNames = TRUE, withFilter = TRUE)

saveWorkbook(wb, "results/Supplemental_Data_MOA-DEseq.xlsx", overwrite = TRUE)
```

The statistical analysis showed that only Block E was affected, other regions (promoter, Block C) were not altered between genotypes. Mutant e12 showed a clear reduction in MOA-seq coverage at Block E that was also statistically significant. For, e14, no signficant differences at Block E was detected, for e16 only Eb, the deleted region was significant. However, Ec had a trend towards signal increase in e14 and e16.

## Plotting

```{r}

plotMA(res_e16_vs_WT, ylim=c(-2,2))

```

```{r}
#d <- plotCounts(dds, gene="Chr1_24335130_24335501"
#, intgroup="genotype", 
#                returnData=TRUE)

#Chr1_24326060_24326259  C_a
#Chr1_24326339_24326438  C_b 
#Chr1_24326769_24327051  afterC_a
#Chr1_24327393_24327489  afterC_b
#Chr1_24331176_24331393  A
#Chr1_24333761_24333871  3UTR
#Chr1_24334846_24335022  E_a
#Chr1_24335130_24335501  E_b
#Chr1_24335900_24336009  E_c

d <- plotCounts(dds, gene="Chr1_24335900_24336009"
, intgroup="genotype", 
                returnData=TRUE)
library("ggplot2")
ggplot(d, aes(x=genotype, y=count)) + 
  geom_point(position=position_jitter(w=0.1,h=0)) + 
  scale_y_log10(breaks=c(25,100,400))
```

```{r}
library(DESeq2)
library(ggplot2)
library(ggrepel)


# Extract MA plot data
df <- plotMA(res_e12_vs_WT, returnData = TRUE)

# Add gene names (rownames must be gene IDs)
df$gene <- rownames(res_e12_vs_WT)

# Choose genes to label
genes_to_label_BlockE <- c("Chr1_24334846_24335022",
"Chr1_24335900_24336009")

genes_to_label_BlockC <- c("Chr1_24326060_24326259","Chr1_24326339_24326438")

genes_to_label_BlockA <- c("Chr1_24331176_24331393")

e12 <- ggplot(df, aes(x = mean, y = lfc)) +
  geom_point(alpha = 0.01, , size = 1, color="gray12") +
  geom_point(data = subset(df, gene %in% genes_to_label_BlockE),
             color = "red", size = 2) +
    geom_point(data = subset(df, gene %in% genes_to_label_BlockA),
             color = "yellow", size = 2) +
    geom_point(data = subset(df, gene %in% genes_to_label_BlockC),
             color = "blue", size = 2) +
  geom_text_repel(data = subset(df, gene %in% genes_to_label_BlockE),
                  aes(label = c("Ea","Ec")),
                  max.overlaps = 20,segment.color = "black", segment.size = 0.5, min.segment.length = 0) +
  geom_text_repel(data = subset(df, gene %in% genes_to_label_BlockA),
                  aes(label = "A"),
                  max.overlaps = 20, nudge_y = 1.5,segment.color = "black", segment.size = 0.5, min.segment.length = 0) +
    geom_text_repel(data = subset(df, gene %in% genes_to_label_BlockC),
                  aes(label = c("Ca","Cb")),
                  max.overlaps = 60, nudge_y = 1,segment.color = "black", segment.size = 0.5, min.segment.length = 0) +
  scale_x_log10() +
    coord_cartesian(
    ylim = c(-2, 2),   # your chosen y‑axis limits
    xlim = c(50,1e+04),
    clip = "off"       # allow labels outside the panel
  ) +

  theme_bw() +
  labs(x = "mean counts", y = "fold-change (log2)") +
theme(axis.title.x=(element_blank()),axis.text.x=(element_blank()))
#  theme(
#    plot.margin = margin(20, 20, 20, 20)  # #space for outside labels
#  ) 

e12
```

```{r}
# Extract MA plot data
df <- plotMA(res_e14_vs_WT, returnData = TRUE)

# Add gene names (rownames must be gene IDs)
df$gene <- rownames(res_e14_vs_WT)

# Choose genes to label
genes_to_label_BlockE <- c("Chr1_24334846_24335022","Chr1_24335130_24335501",
"Chr1_24335900_24336009")

genes_to_label_BlockC <- c("Chr1_24326060_24326259","Chr1_24326339_24326438")

genes_to_label_BlockA <- c("Chr1_24331176_24331393")

e14 <- ggplot(df, aes(x = mean, y = lfc)) +
  geom_point(alpha = 0.01, size = 1, color="gray12") +
  geom_point(data = subset(df, gene %in% genes_to_label_BlockE),
             color = "red", size = 2) +
    geom_point(data = subset(df, gene %in% genes_to_label_BlockA),
             color = "yellow", size = 2) +
    geom_point(data = subset(df, gene %in% genes_to_label_BlockC),
             color = "blue", size = 2) +
  geom_text_repel(data = subset(df, gene %in% genes_to_label_BlockE),
                  aes(label = c("Ea","Eb","Ec")),
                  max.overlaps = 20, nudge_y=-1.0,segment.color = "black", segment.size = 0.5, min.segment.length = 0) +
  geom_text_repel(data = subset(df, gene %in% genes_to_label_BlockA),
                  aes(label = "A"),
                  max.overlaps = 20, nudge_y = 1.5,segment.color = "black", segment.size = 0.5, min.segment.length = 0) +
    geom_text_repel(data = subset(df, gene %in% genes_to_label_BlockC),
                  aes(label = c("Ca","Cb")),
                  max.overlaps = 20,  nudge_y = 1.0,segment.color = "black", segment.size = 0.5, min.segment.length = 0) +
  scale_x_log10() +
    coord_cartesian(
    ylim = c(-2, 2),   # your chosen y‑axis limits
    xlim = c(50,10000),
    clip = "off"       # allow labels outside the panel
  ) +

  theme_bw() +
    labs(x = "mean counts", y = "fold-change (log2)") +
theme(axis.title.x=(element_blank()),axis.text.x=(element_blank()))
#  theme(
#    plot.margin = margin(20, 20, 20, 20)  # #space for outside labels
#  ) 

e14
```

```{r}
df <- plotMA(res_e16_vs_WT, returnData = TRUE)

# Add gene names (rownames must be gene IDs)
df$gene <- rownames(res_e16_vs_WT)

# Choose genes to label
genes_to_label_BlockE <- c("Chr1_24334846_24335022",
"Chr1_24335900_24336009")

genes_to_label_BlockC <- c("Chr1_24326060_24326259","Chr1_24326339_24326438")

genes_to_label_BlockA <- c("Chr1_24331176_24331393")

e16 <- ggplot(df, aes(x = mean, y = lfc)) +
  geom_point(alpha = 0.01, size = 1, color="gray12") +
  geom_point(data = subset(df, gene %in% genes_to_label_BlockE),
             color = "red", size = 2) +
    geom_point(data = subset(df, gene %in% genes_to_label_BlockA),
             color = "yellow", size = 2) +
    geom_point(data = subset(df, gene %in% genes_to_label_BlockC),
             color = "blue", size = 2) +
  geom_text_repel(data = subset(df, gene %in% genes_to_label_BlockE),
                  aes(label = c("Ea","Ec")),
                  max.overlaps = 20,nudge_y=-1.0,segment.color = "black", segment.size = 0.5, min.segment.length = 0) +
  geom_text_repel(data = subset(df, gene %in% genes_to_label_BlockA),
                  aes(label = "A"),
                  max.overlaps = 20, nudge_y=1.5,segment.color = "black", segment.size = 0.5, min.segment.length = 0) +
    geom_text_repel(data = subset(df, gene %in% genes_to_label_BlockC),
                  aes(label = c("Ca","Cb")),
                  max.overlaps = 20, nudge_y=1,segment.color = "black", segment.size = 0.5, min.segment.length = 0) +
  scale_x_log10() +
    coord_cartesian(
    ylim = c(-2, 2),   # your chosen y‑axis limits
    xlim = c(50,10000),
    clip = "off"       # allow labels outside the panel
  ) +

  theme_bw() +
      labs(x = "mean counts", y = "fold-change (log2)") 
#  theme(
#    plot.margin = margin(20, 20, 20, 20)  # #space for outside labels
#  ) 

e16
```

```{r}
library(ggpubr)
pdf("Peaks/MA_plot_of_Peaks_compact.pdf", width = 4, height = 8) 
ggarrange(e12,e14,e16, ncol = 1, nrow = 3)
dev.off()

```
