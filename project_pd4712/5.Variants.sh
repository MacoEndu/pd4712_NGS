#!/bin/bash

echo "Rozpoczęcie analizy wariantów "
mkdir -p variants

SAMPLES=('wMelCS_b' 'Octoless' 'wMelPop')
REFERENCE="genome_index/Wolbachia_wMel_ref_genome.fna"

#Analiza
'''
for SAMPLE in "${SAMPLES[@]}"; do
  
  #Szacowanie stopnia pokrycia wariantu
  echo "Szacowania stopnia pokrycia ${SAMPLE}"
  bcftools mpileup -O b -o variants/${SAMPLE}_raw_variants.bcf -f ${REFERENCE} -q 20 -q 30 mapped/Wolbachia_${SAMPLE}_fixed_sorted_dedup.bam
  
  #Identyfikacja indeli i SNP w wariuantach
  echo "Identyfikacja indeli i SNP w wariantach ${SAMPLE}"
  bcftools call --ploidy 1 -m -v -o variants/${SAMPLE}_final_variants.vcf variants/${SAMPLE}_raw_variants.bcf
done
echo "Koniec analizy wariantów"
'''
#Wyświetlanie wariantów
echo "WARIANTY PRÓBEK:"
for SAMPLE in "${SAMPLES[@]}"; do
  SNP_COUNT=$(bcftools view -v snps variants/${SAMPLE}_final_variants.vcf | grep -v "^#" | wc -l)
  INDEL_COUNT=$(bcftools view -v indels variants/${SAMPLE}_final_variants.vcf | grep -v "^#" | wc -l)
  echo "Ilość SNP w próbce ${SAMPLE}:		${SNP_COUNT}"
  echo "Ilość INDELi w próbce ${SAMPLE}:	${INDEL_COUNT}"
done

for SAMPLE in "${SAMPLES[@]}"; do
  echo "Filtrowanie wariantu ${SAMPLE}_filtered_final_variants.vcf ..."
  bcftools filter \
    -e 'QUAL < 30 || DP < 25 '  \
    -O v \
    -o "variants/${SAMPLE}_filtered_final_variants.vcf" \
    "variants/${SAMPLE}_final_variants.vcf"
done
echo "Koniec filtrowania wariantów"

#Wyświetlanie filtrowanych wariantów
echo "WARIANTY FILTROWANYCH PRÓBEK:"
for SAMPLE in "${SAMPLES[@]}"; do
  SNP_COUNT=$(bcftools view -v snps variants/${SAMPLE}_filtered_final_variants.vcf | grep -v "^#" | wc -l)
  INDEL_COUNT=$(bcftools view -v indels variants/${SAMPLE}_filtered_final_variants.vcf | grep -v "^#" | wc -l)
  echo "Ilość SNP w próbce ${SAMPLE}_filtered:		${SNP_COUNT}"
  echo "Ilość INDELi w próbce ${SAMPLE}_filtered:	${INDEL_COUNT}"
done

