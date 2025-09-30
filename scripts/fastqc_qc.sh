# FastQC pipeline for raw reads
mkdir -p ../qc_results/raw
fastqc ../raw_data/*.fastq -o ../qc_results/raw
echo "FastQC complete! Reports saved in qc_results/raw"



#-----------Trimming with Trimmomatic-----------

# Note: Replace 'TruSeq3-PE.fa' with your library-specific adapter file if needed
# FastQC showed no adapter contamination for this dataset, but this step is included for general use
mkdir -p ../trimmed_data
java -jar /home/anushri/anaconda3/share/trimmomatic-0.40-0/trimmomatic.jar PE -threads 4 \   #replace with your own trimmomatic path
../raw_data/SRR16122872_1.fastq   ../raw_data/SRR16122872_2.fastq \
../trimmed_data/SRR16122872_1_paired.fastq ../trimmed_data/SRR16122872_1_unpaired.fastq \
../trimmed_data/SRR16122872_2_paired.fastq ../trimmed_data/SRR16122872_2_unpaired.fastq \
ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
SLIDINGWINDOW:4:20 MINLEN:50

echo "Trimming complete. Trimmed reads saved in trimmed_data/"
