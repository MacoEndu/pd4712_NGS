echo "Pobieranie sekwencji szczepów bakterii Wolbachia"

SAMPLES=('wMelCS_b-SRR10438626' 'Octoless-SRR10466882' 'wMelPop-SRR10466884')

for PAIR in "${SAMPLES[@]}"; do
    NAME=$(echo $PAIR | cut -d'-' -f1)  # nazwa szczepu
    SRR=$(echo $PAIR | cut -d'-' -f2)   # numer SRR

   # echo "Pobieranie próbki ${NAME}: ${SRR}..."
   # fastq-dump $SRR --split-3 --skip-technical --gzip
    mv ${SRR}_1.fastq.gz ${NAME}_1.fastq.gz
    mv ${SRR}_2.fastq.gz ${NAME}_2.fastq.gz
   # echo "Pobieranie próbki ${NAME} zakończone!"
    
    # Analiza FastQC
    echo "Uruchamiam FastQC dla ${NAME}..."
    fastqc "${NAME}_1.fastq.gz" "${NAME}_2.fastq.gz" -o raw_data_reports 
    
    echo "Analiza $NAME zakończona!"
done
# Złączenie raportów MultiQC
echo "Generowanie raportu zbiorczego MultiQC..."
multiqc raw_data_reports -o raw_data_reports


