#you need directories: raw_data,qc_results, results, reference

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

# -------------------------------
#fastQC on trimmed reads
# -------------------------------
echo "Running FastQC on trimmed reads..."
mkdir -p ../qc_results/trimmed
fastqc ../trimmed_data/*_paired.fastq -o ../qc_results/trimmed
echo "FastQC complete! Reports saved in qc_results/trimmed"

#___mapping trimmed reads (BWA+samtools)--------
mkdir -p ../mapped
#Define reference genome path
#Make sure you have indexed the reference using: bwa index ref_genome.fasta

REF_GENOME=../reference/PA.fasta

# Paired-end reads
R1=../trimmed_data/SRR16122872_1_paired.fastq
R2=../trimmed_data/SRR16122872_2_paired.fastq

#run BWA mem
bwa mem -t 4 $REF_GENOME $R1 $R2 > ../mapped/aligned.sam

# Convert SAM → BAM, sort, and index
samtools view -Sb ../mapped/aligned.sam > ../mapped/aligned.bam
samtools sort ../mapped/aligned.bam > ../mapped/sorted.bam
samtools index ../mapped/sorted.bam

echo "mapping completed"

#-------variants calling----------
mkdir -p ../variants

# Input: sorted BAM and reference genome
BAM=../mapped/sorted.bam
REF=../reference/PA.fasta
RAW_BCF=../variants/raw.bcf
VAR=../variants/variants.vcf
# Call variants
bcftools mpileup -f $REF $BAM -Ob -o $RAW_BCF
bcftools call -mv -o $VAR $RAW_BCF

echo "Variant calling complete! VCF saved as $VAR" 

