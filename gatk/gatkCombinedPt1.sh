#!/bin/bash
#SBATCH -J gatk_DC_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2 # Adjust this as needed ***********
#SBATCH --time=50:00:00   # Time limit
#SBATCH --array=1-9    # Number of files to process (adjust this to your needs) ***********

# Initialize Conda (if not already initialized)
eval "$(conda shell.bash hook)"
# Load necessary modules
module load picard/2.18.14
module load R/4.0.0

# Variables
cache="/mainfs/scratch/lb3e23/cache/vep/"
vcf_file="/mainfs/scratch/lb3e23/Resources/GRch38/snpVCF/dbSNP/chr_00-All.vcf"
ref="/mainfs/scratch/lb3e23/Resources/GRch38/GRCh38.primary_assembly.genome.fa"
samples=("no_47" "no_49" "no_43" "no_45" "no_40" "P1641" "NB2538" "B_FKRN" "HV600")
sample=${samples[${SLURM_ARRAY_TASK_ID}-1]}
base_directory="/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/STAR/"
sample_path=$(find "$base_directory" -type f -name "${sample}*.sorted.bam")
output_folder=/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/gatk/${sample}/
mkdir -p ${output_folder}

picard MarkDuplicates \
I="${sample_path}" \
O=${output_folder}${sample}_marked_duplicates.bam \
M=${output_folder}${sample}_marked_dup_metrics.txt


#**********************************************************************************

# Creating .dict files (only have to once, comment out if reference genome .dict file is already present). Will have to run separately
# The picard version on the module is older and uses Java 8, we are on java 17 as of 30/01/2024. So when running SplitCigarReads, do not load in
# Picard as a module.

#picard CreateSequenceDictionary \
  #R=$ref \
  #O="${ref%.fa}.dict"
  
module unload picard/2.18.14
conda activate gatk4

# SplitCigarReads
gatk SplitNCigarReads \
  -R $ref \
  -I ${output_folder}${sample}_marked_duplicates.bam \
  -O ${output_folder}${sample}_cigar.bam 

#*************************************************************************************
# Generates report, can be in csv or pdf. Assess the quality of recalibration.
gatk AnalyzeCovariates \
 -bqsr ${output_folder}${sample}_recalibration_report.table \
 -plots ${sample}_AnalyzeCovariates.pdf
 
#************************************************************************************
conda deactivate
module load picard

picard AddOrReplaceReadGroups \
       I=${output_folder}${sample}_cigar.bam \
       O=${output_folder}${sample}_addedReadGroup.bam \
       RGLB=lib1 \
       RGPL=ILLUMINA \
       RGPU=unit1 \
       RGSM=${sample}
       
module unload picard
#****************************************************************************************
# Index the VCF file - only need to do once
# gatk IndexFeatureFile \
# -I $vcf_file

# BaseRecalibrator
conda activate gatk4
gatk BaseRecalibrator \
   -R $ref \
   -I ${output_folder}${sample}_addedReadGroup.bam \
   --known-sites $vcf_file \
   -O ${output_folder}${sample}_recalibration_report.table
   
#****************************************************************************************
gatk ApplyBQSR \
   -R $ref \
   -I ${output_folder}${sample}_addedReadGroup.bam \
   --bqsr-recal-file ${output_folder}${sample}_recalibration_report.table \
   -O ${output_folder}${sample}_BQSR.bam
   
#****************************************************************************************

gatk HaplotypeCaller \
  --input ${output_folder}${sample}_BQSR.bam \
  --output ${output_folder}${sample}_haplotypeCaller.vcf \
  -R $ref
  
#******************************************************************************************

# Call gatk VariantFiltration
# Set the option --set-filtered-genotype-to-no-call to true if you want to remove the entries that do not meet the criteria. The default is false and can omit this option if you want to keep it as false.
gatk VariantFiltration \
    -R $ref \
    -V "${output_folder}${sample}_haplotypeCaller.vcf" \
    -O "${output_folder}${sample}_variantFilteredByQuality.vcf" \
    --filter-name "variantQual50" \
    --filter-expression "QUAL < 50" \
    --set-filtered-genotype-to-no-call
	
#******************************************************************************************
conda activate bcftools
input_vcf="${output_folder}${sample}_variantFilteredByQuality.vcf"

bcftools filter -i 'INFO/FS <= 30 && INFO/DP >= 8 && FORMAT/GQ[0] >= 16 && INFO/QD >= 2 && FILTER="PASS"' \
    "$input_vcf" \
    -Ov -o "${output_folder}${sample}_bcftools_filtered.vcf"


#********************************************************************************************
conda activate vep
vep -i "${output_folder}${sample}_bcftools_filtered.vcf" -o "${output_folder}${sample}_vep_filtered.vcf" \
    --cache --dir_cache $cache \
    --vcf --offline --af\
    --fasta $ref --distance 5000 --nearest gene \
	--fork 1

#*******************************************************************************************
# Remove bam files to save space
rm ${output_folder}${sample}_marked_duplicates.bam
rm ${output_folder}${sample}_cigar.bam
rm ${output_folder}${sample}_addedReadGroup.bam