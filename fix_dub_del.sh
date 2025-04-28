echo "Fixing and PCR duplicates deletion"

samples=('Ecoli_rep1' 'Ecoli_rep2' 'Ecoli_rep3')

for sample in "${samples[@]}"; do
#End fixing
samtools fixmate -m ${sample}.bam ${sample}_fixmate.bam
#Sorting
samtools sort ${sample}_fixmate.bam -o ${sample}_fixmate_sorted.bam
#Indexing
samtools index ${sample}_fixmate_sorted.bam
#PCR duplicates deletion
samtools markdup -r ${sample}_fixmate_sorted.bam ${sample}_fixmate_sorted_dedup.bam
done
echo "End of the fixing and PCR duplicate deletion"

