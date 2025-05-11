echo  "USUWANIE ADAPTERÓW"
mkdir trimmed
mkdir trimmed_data_reports
SAMPLES=('wMelCS_b' 'Octoless' 'wMelPop')
for SAMPLE in "${SAMPLES[@]}"; do
	echo "Przycinanie adapterów ${SAMPLE}..."
	trimmomatic PE -threads 4 -phred33 ${SAMPLE}_1.fastq.gz ${SAMPLE}_2.fastq.gz trimmed/${SAMPLE}_1_trimmed.fastq.gz /dev/null trimmed/${SAMPLE}_2_trimmed.fastq.gz /dev/null ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:50
	
	fastqc "trimmed/${SAMPLE}_1_trimmed.fastq.gz" "trimmed/${SAMPLE}_2_trimmed.fastq.gz" -o trimmed_data_reports/
done;
echo "Generowanie raportu zbiorowego..."
multiqc trimmed_data_reports/ -o trimmed_data_reports/
echo "Raport zbiorowy gotowy w /trimmed_data_reports/muliqcreports"	

