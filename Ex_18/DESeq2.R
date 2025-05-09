#Wczytanie danych
raw_counts<-read.table("MT_WT_reps_transcripts_counts.tabular", sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Modyfikacja nazw kolumn (Zamiast WT_rep1_WT_rep1 na WT_rep1) i innych parametrów
name_mod <- substr(colnames(raw_counts), 1, 7)
colnames(raw_counts) <- name_mod

WT<-grep("WT_",colnames(raw_counts))
MT<-grep("MT_",colnames(raw_counts))
counts<-cbind(raw_counts[,WT],raw_counts[,MT])
rownames(counts)<-raw_counts[,1]

#Stworzony nowy data frame do obróbki
condition <- factor(c(rep("WT", 2), rep("MT", 2)))
coldata <- data.frame(row.names=colnames(counts), condition)

#Modyfikacja id ensemble
ensembl_ids <- rownames(counts)
no_ensembl_ids <- gsub("\\..*$", "", ensembl_ids)
rownames(counts) <- no_ensembl_ids

library(biomaRt)

#Utworzenie potrzebnej bazy danych

mart_connection <- useMart("ensembl", dataset = 'hsapiens_gene_ensembl')
attr <- listAttributes(mart_connection)
gen <- getBM(attributes = c("ensembl_gene_id",
                            "hgnc_symbol",
                            "chromosome_name",
                            "start_position",
                            "percentage_gene_gc_content",
                            "gene_biotype",
                            "description",
                            "entrezgene_id"),
             filters = "ensembl_gene_id",
             values = rownames(counts),
             mart = mart_connection)


#Praca w DESeq2 nad danymi
library(DESeq2)

dds<- DESeqDataSetFromMatrix(countData = counts, colData = coldata, design = ~ condition)
dds2<-DESeq(dds)
deseq_results <- results(dds2)
head(deseq_results)