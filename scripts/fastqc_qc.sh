# FastQC pipeline for raw reads
mkdir -p ../qc_results/raw
fastqc ../raw_data/*.fastq -o ../qc_results/raw
echo "FastQC complete! Reports saved in qc_results/raw"

