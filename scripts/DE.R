install.packages("BiocManager")
BiocManager::install("DESeq2")
BiocManager::install("clusterProfiler")
BiocManager::install("org.Hs.eg.db")

library(DESeq2)
library(clusterProfiler)
library(org.Hs.eg.db)
library(ggplot2)


raw_data <- read.table("/Users/Aiden/Desktop/UNIBE_DATA/RNA-seq_data/GRch38_with_cRP.txt", header=TRUE, sep="\t")


############# 5. Exploratory Data analysis

#remove gene name so that number of columns matches number of conditions, but add it to the row names of cunt_data so the gene names are preserved
gene_names <- raw_data[,1]
count_data <- raw_data[, -1]
rownames(count_data) <- gene_names
count_matrix <- as.matrix(count_data)


sample_info <- data.frame(
  row.names = c("HER21", "HER22", "HER23", "NonTNBC1", "NonTNBC2", "NonTNBC3", "Normal1", "Normal2", "Normal3", "TNBC1", "TNBC2", "TNBC3"),
  condition = c("HER2", "HER2", "HER2", "NonTNBC", "NonTNBC", "NonTNBC", "Normal", "Normal", "Normal", "TNBC", "TNBC", "TNBC")
)

#print(head(count_matrix))

#Checks to ensure that the sample_info contains the same condition names as the imported feature counts matrix,
#and that there is no data corruption like negative gene count values
negative_indices <- which(raw_data[,-1] < 0, arr.ind = TRUE)
if (nrow(negative_indices) > 0) {
  print("Negative values found at the following locations:")
  print(negative_indices)
  stop("Count matrix contains negative values.")
}
if (!all(colnames(count_matrix) == rownames(sample_info))) {
  stop("Column names of count matrix do not match row names of sample information.")
}

#Create a DEseq object from the gene count matrix and sample_info, which groups the duplicate by the type of breast cancer
#design specifies that we are grouping by type of cancer, assign row names to gene names from feature count matrix
obj <- DESeqDataSetFromMatrix(count_matrix,sample_info, design = ~ condition)

#Normalize data
dds <- DESeq(obj)

#make sure the model fits
dispEst <- plotDispEsts(dds)

#Stabilize variance of low count genes
vsd <- vst(dds, blind=TRUE)

#Plot primary component analysis of breast cancer types
pca_plot <- plotPCA(vsd, intgroup="condition")
print(pca_plot)

#Pairwise comparisons

#resTNBCvsNon <- results(dds, contrast= c("condition", "TNBC", "NonTNBC"))
resTNBCvsHER <- results(dds, contrast= c("condition", "TNBC", "HER"))
#resTNBCvsNorm <- results(dds, contrast= c("condition", "TNBC", "Normal"))
#resNonvsHER <- results(dds, contrast= c("condition", "NonTNBC", "HER"))
#resNonvsNorm <- results(dds, contrast= c("condition", "NonTNBC", "Normal"))
#resHERvsNorm <- results(dds, contrast= c("condition", "HER", "Normal"))

#Pairwise contrast stats 
significant_results_TNBCvsHER <- resTNBCvsHER[which(resTNBCvsHER$padj < .05), ]
number_significant_genes <- nrow(significant_results_TNBCvsHER)

log2FoldChange_values <- significant_results_TNBCvsHER@listData$log2FoldChange
upregulatedTNBC <- length(log2FoldChange_values[log2FoldChange_values > 0])
downregulatedTNBC <- length(log2FoldChange_values[log2FoldChange_values < 0])

print(number_significant_genes)
print(upregulatedTNBC)
print(downregulatedTNBC)


# Create volcano plots

res_df <- as.data.frame(resTNBCvsHER)
res_df$gene <- rownames(res_df)  # Add gene names if needed

ggplot(res_df, aes(x = log2FoldChange, y = -log10(padj))) +
  geom_point(aes(color = ifelse(padj < 0.05 & abs(log2FoldChange) > 1, "Significant", "Not Significant")), alpha = 0.6) +
  scale_color_manual(values = c("Significant" = "red", "Not Significant" = "black")) +
  theme_minimal() +
  labs(
    x = "Log2 Fold Change",
    y = "Log10 Adjusted p-value",
    title = "TNBC vs HER2",
    color = "Significance"
  ) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "blue") +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "blue") +
  scale_x_continuous(expand = c(0, 0), limits = c(-30, 30)) +  # Set x-axis limits
  scale_y_continuous(expand = c(0, 0), limits = c(0, 30)) +  # Set y-axis limits
  theme(plot.title = element_text(hjust = 0.5))  # Center the title





######## 6. Differential expression analysis:
#Checking up regulation vs down regulation:

upregulated_0_1x <- sum(significant_results_TNBCvsHER$log2FoldChange > 0 & 
                          significant_results_TNBCvsHER$log2FoldChange <= 1)
downregulated_0_1x <- sum(significant_results_TNBCvsHER$log2FoldChange < 0 & 
                            significant_results_TNBCvsHER$log2FoldChange >= -1)

upregulated_1_2x <- sum(significant_results_TNBCvsHER$log2FoldChange > 1 & 
                          significant_results_TNBCvsHER$log2FoldChange <= 2)
downregulated_1_2x <- sum(significant_results_TNBCvsHER$log2FoldChange < -1 & 
                            significant_results_TNBCvsHER$log2FoldChange >= -2)

upregulated_2_3x <- sum(significant_results_TNBCvsHER$log2FoldChange > 2 & 
                          significant_results_TNBCvsHER$log2FoldChange <= 3)
downregulated_2_3x <- sum(significant_results_TNBCvsHER$log2FoldChange < -2 & 
                            significant_results_TNBCvsHER$log2FoldChange >= -3)

upregulated_3_4x <- sum(significant_results_TNBCvsHER$log2FoldChange > 3 & 
                          significant_results_TNBCvsHER$log2FoldChange <= 4)
downregulated_3_4x <- sum(significant_results_TNBCvsHER$log2FoldChange < -3 & 
                            significant_results_TNBCvsHER$log2FoldChange >= -4)

upregulated_4_5x <- sum(significant_results_TNBCvsHER$log2FoldChange > 4 & 
                          significant_results_TNBCvsHER$log2FoldChange <= 5)
downregulated_4_5x <- sum(significant_results_TNBCvsHER$log2FoldChange < -4 & 
                            significant_results_TNBCvsHER$log2FoldChange >= -5)

upregulated_5_6x <- sum(significant_results_TNBCvsHER$log2FoldChange > 5 & 
                          significant_results_TNBCvsHER$log2FoldChange <= 6)
downregulated_5_6x <- sum(significant_results_TNBCvsHER$log2FoldChange < -5 & 
                            significant_results_TNBCvsHER$log2FoldChange >= -6)

upregulated_6_7x <- sum(significant_results_TNBCvsHER$log2FoldChange > 6 & 
                          significant_results_TNBCvsHER$log2FoldChange <= 7)
downregulated_6_7x <- sum(significant_results_TNBCvsHER$log2FoldChange < -6 & 
                            significant_results_TNBCvsHER$log2FoldChange >= -7)

# Print results
cat("Upregulated 0-1x: ", upregulated_0_1x, "\n")
cat("Downregulated 0-1x: ", downregulated_0_1x, "\n")

cat("Upregulated 1-2x: ", upregulated_1_2x, "\n")
cat("Downregulated 1-2x: ", downregulated_1_2x, "\n")

cat("Upregulated 2-3x: ", upregulated_2_3x, "\n")
cat("Downregulated 2-3x: ", downregulated_2_3x, "\n")

cat("Upregulated 3-4x: ", upregulated_3_4x, "\n")
cat("Downregulated 3-4x: ", downregulated_3_4x, "\n")

cat("Upregulated 4-5x: ", upregulated_4_5x, "\n")
cat("Downregulated 4-5x: ", downregulated_4_5x, "\n")

cat("Upregulated 5-6x: ", upregulated_5_6x, "\n")
cat("Downregulated 5-6x: ", downregulated_5_6x, "\n")

cat("Upregulated 6-7x: ", upregulated_6_7x, "\n")
cat("Downregulated 6-7x: ", downregulated_6_7x, "\n")


sum(upregulated_0_1x, upregulated_1_2x, upregulated_2_3x, upregulated_3_4x, upregulated_4_5x, upregulated_5_6x, upregulated_6_7x, downregulated_0_1x, downregulated_1_2x, downregulated_2_3x, downregulated_3_4x,
    downregulated_4_5x, downregulated_5_6x, downregulated_6_7x)
min(significant_results_TNBCvsHER$log2FoldChange)

#### 7. Overrepresentation analysis

#Expression level of specific genes from original publication, use raw_data so we can view gene name
original_SPARC <- "ENSG00000113140"
original_RAB21 <- "ENSG00000080371"
original_TMEM219 <- "ENSG00000149932"
original_FN1 <- "ENSG00000115414"
original_APOE <- "ENSG00000130203"
original_PP1B <- "ENSG00000213639"
original_OAZ1 <- "ENSG00000104904"

SPARC_counts <- counts(dds, normalized=TRUE)[original_SPARC, ]
RAB21_counts <- counts(dds, normalized=TRUE)[original_RAB21, ]
TMEM219_counts <- counts(dds, normalized=TRUE)[original_TMEM219, ]
FN1_counts <- counts(dds, normalized=TRUE)[original_FN1, ]
APOE_counts <- counts(dds, normalized=TRUE)[original_APOE, ]
PP1B_counts <- counts(dds, normalized=TRUE)[original_PP1B, ]
OAZ1_counts <- counts(dds, normalized=TRUE)[original_OAZ1, ]

print(APOE_counts)
print(FN1_counts)
print(TMEM219_counts)
print(RAB21_counts)
print(SPARC_counts)
print(PP1B_counts)
print(OAZ1_counts)

#Overrepresentation analysis:
#use rownames function to extract gene names from DEseq object
goEA_ALL <- enrichGO(gene=rownames(significant_results_TNBCvsHER), universe=rownames(count_matrix), OrgDb=org.Hs.eg.db, ont="ALL", keyType="ENSEMBL")
goEA_BP <- enrichGO(gene=rownames(significant_results_TNBCvsHER), universe=rownames(count_matrix), OrgDb=org.Hs.eg.db, ont="BP", keyType="ENSEMBL")
goEA_MF <- enrichGO(gene=rownames(significant_results_TNBCvsHER), universe=rownames(count_matrix), OrgDb=org.Hs.eg.db, ont="MF", keyType="ENSEMBL")
goEA_CC <- enrichGO(gene=rownames(significant_results_TNBCvsHER), universe=rownames(count_matrix), OrgDb=org.Hs.eg.db, ont="CC", keyType="ENSEMBL")

goEA_all_DP <- dotplot(goEA_ALL, showCategory=20) + ggtitle("dotplot for HER vs TNBC ALL")
goEA_BP_DP <- dotplot(goEA_BP, showCategory=20) + ggtitle("dotplot for HER vs TNBC BP")
goEA_MF_DP <- dotplot(goEA_MF, showCategory=10) + 
  ggtitle("TNBC vs HER2") + 
  scale_x_continuous(limits = c(0.005, 0.05)) +  # Set x-axis limit to 0.05
  theme(plot.title = element_text(hjust = 0.5))  # Center the title


goEA_CC_DP <- dotplot(goEA_CC, showCategory=20) + ggtitle("dotplot for HER vs TNBC CC")
