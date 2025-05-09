#odwrócenie kolejności WT vs MT -> MT vs MT
deseq_results <- results(dds2, contrast = c("condition", "MT", "WT"))
deseq_results

#Filtracja wyników log2FoldChange>5 i padj<0.05
significant<-which(deseq_results$log2FoldChange>5 & deseq_results$padj<0.05 & !is.na(deseq_results$log2FoldChange) & !is.na(deseq_results$padj))

head(significant)
significant_genes <-gen[match(rownames(deseq_results)[significant],gen[,1]),2]
as.data.frame(significant_genes)

#Wynik ekspresji genu RUNX3 (ENSG00000020633) 
runx3_result <- deseq_results[rownames(deseq_results) == "ENSG00000020633", ]
print(runx3_result)

#Wizualizacja na wykresach

library(EnhancedVolcano)

#Wykres VulcanoPlot
pdf(file = "volcano.pdf")
gene_symbols <- gen$hgnc_symbol[match(rownames(deseq_results), gen$ensembl_gene_id)]

EnhancedVolcano(deseq_results,
                lab = gene_symbols,
                x = "log2FoldChange",
                y = "padj",
                title = "WT vs MT")
dev.off()
