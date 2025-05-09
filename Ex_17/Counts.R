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
