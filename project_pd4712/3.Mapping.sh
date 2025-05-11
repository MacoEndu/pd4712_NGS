#!/bin/bash

mkdir mapped

SAMPLES=('wMelCS_b' 'Octoless' 'wMelPop')
REFERENCE="genome_index/Wolbachia"  # Podstawowa nazwa indeksu BWA

for SAMPLE in "${SAMPLES[@]}"; do
    echo "Mapowanie odczytów ${SAMPLE}..."
    bwa mem -t 15 $REFERENCE \
    trimmed/"${SAMPLE}_1_trimmed.fastq.gz" \
    trimmed/"${SAMPLE}_2_trimmed.fastq.gz" \
    | samtools view -bS - > "mapped/Wolbachia_${SAMPLE}.bam"
    echo "Oznaczanie odczytów ${SAMPLE}..."
    samtools fixmate -m mapped/Wolbachia_${SAMPLE}.bam mapped/Wolbachia_${SAMPLE}_fixed.bam
    echo "Sortowanie odczytów ${SAMPLE}..."
    samtools sort  mapped/Wolbachia_${SAMPLE}_fixed.bam -o mapped/Wolbachia_${SAMPLE}_fixed_sorted.bam
    echo "Indeksowanie odczytów ${SAMPLE}..."
    samtools index mapped/Wolbachia_${sample}_fixed_sorted.bam
    echo "Deduplikowanie odczytów ${SAMPLE}..."
    samtools markdup -r mapped/Wolbachia_${SAMPLE}_fixed_sorted.bam mapped/Wolbachia_${SAMPLE}_fixed_sorted_dedup.bam
done

echo "Koniec mappingu, oznaczenia, sortowania, indeksowania i deduplikowania odczytów"

