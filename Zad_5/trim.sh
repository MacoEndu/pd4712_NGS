#!/bin/bash
echo "Trimming"
mkdir Trimmed
trimmomatic PE -threads 4 -phred33 SRR25629153_1.fastq.gz SRR25629153_2.fastq.gz Trimmed/SRR25629153_1_trimmed.fastq.gz /dev/null Trimmed/SRR25629153_2_trimmed.fastq.gz /dev/null LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:50

trimmomatic PE -threads 4 -phred33 SRR25629154_1.fastq.gz SRR25629154_2.fastq.gz Trimmed/SRR25629154_1_trimmed.fastq.gz /dev/null Trimmed/SRR25629154_2_trimmed.fastq.gz /dev/null LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:50
