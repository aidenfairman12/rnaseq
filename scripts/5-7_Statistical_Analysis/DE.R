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


######## 6. Differential expression analysis:
#Pairwise comparisons
resTNBCvsHER <- results(dds, contrast= c("condition", "TNBC", "HER"))


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

#### 7. Overrepresentation analysis

#use gene ids as defined in ensembl
original_RAB21 <- "ENSG00000080371"
original_APOE <- "ENSG00000130203"

RAB21_counts <- counts(dds, normalized=TRUE)[original_RAB21, ]
APOE_counts <- counts(dds, normalized=TRUE)[original_APOE, ]

print(APOE_counts)
print(RAB21_counts)

#Overrepresentation analysis:
#use rownames function to extract gene names from DEseq object
#goEA_ALL <- enrichGO(gene=rownames(significant_results_TNBCvsHER), universe=rownames(count_matrix), OrgDb=org.Hs.eg.db, ont="ALL", keyType="ENSEMBL")
#goEA_BP <- enrichGO(gene=rownames(significant_results_TNBCvsHER), universe=rownames(count_matrix), OrgDb=org.Hs.eg.db, ont="BP", keyType="ENSEMBL")
goEA_MF <- enrichGO(gene=rownames(significant_results_TNBCvsHER), universe=rownames(count_matrix), OrgDb=org.Hs.eg.db, ont="MF", keyType="ENSEMBL")
#goEA_CC <- enrichGO(gene=rownames(significant_results_TNBCvsHER), universe=rownames(count_matrix), OrgDb=org.Hs.eg.db, ont="CC", keyType="ENSEMBL")

goEA_MF_DP <- dotplot(goEA_MF, showCategory=10) + 
  ggtitle("TNBC vs HER2") + 
  scale_x_continuous(limits = c(0.005, 0.05)) +  # Set x-axis limit to 0.05
  theme(plot.title = element_text(hjust = 0.5))  # Center the title

