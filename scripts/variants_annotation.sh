#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
# Variant Annotation Script for Bacterial Genome
# Input: VCF file from variant calling
# Output: Annotated VCF
# =============================================
#in snpEff folder, create a data folder(ref_genome).
#In which add the reference fasta (as sequences.fa) and GFF3 file (as genes.gff).
#in snpEff.config, add- ref_genome.genome:ref_genome
#make dictionary:java -jar snpEff_latest_core/snpEff/snpEff.jar build -gff3 -v ref_genome(please add your path) 

# -------------------------------
#Define paths
# -------------------------------
mkdir -p ../variants/annotated
VCF=../variants/variants.vcf
ANNOTATED_VCF=../variants/annotated/variants_annotated.vcf
snpEff=../variants/snpEff_latest_core/snpEff/snpEff.jar
# -------------------------------
# Annotate with SnpEff
# -------------------------------
echo "Annotating variants with SnpEff..."
java -jar $snpEff ann ref_genome $VCF > $ANNOTATED_VCF
echo "Annotation complete! Annotated VCF saved in ../variants/annotated/"
