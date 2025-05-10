#Próbki
SAMPLES=(
    "SRR25629154"
    "SRR25629153"
)
#Skrypt zakłada już trimmowane, zmapowane, posortowanie i pozbawione duplikatów próbki z końcówką _dedup.bam.
genome_path="/home/wiktor/Pulpit/pd4712_NGS/virtual/GCF_000005845.2_ASM584v2_genomic.fna"
for sample in "${SAMPLES[@]}"; do
  
  #Szacowanie stopnia pokrycia wariantu
  bcftools mpileup -O b -o ${sample}_raw_variants.bcf -f ${genome_path} -q 20 -q 30 ${sample}_dedup.bam
  
  #Identyfikacja indeli i SNP w wariuantach
  bcftools call --ploidy 1 -m -v -o ${sample}_final_variants.vcf ${sample}_raw_variants.bcf
done
echo "Koniec analizy"
