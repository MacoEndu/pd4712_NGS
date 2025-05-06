#!/bin/bash
echo "Mapping"
samples=('SRR25629154' 'SRR25629153')
i=2
for sample in "${samples[@]}"
do
bwa mem -t 15 \
genome_index/e_coli_index \
Trimmed/${sample}_1_trimmed.fastq.gz Trimmed/${sample}_2_trimmed.fastq.gz | samtools view -bS - >Ecoli_rep${i}.bam
((i++))
done
echo "Koniec mappingu"
