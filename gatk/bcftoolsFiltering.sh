#!/bin/bash
#SBATCH -J gatk_DC_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1 # Adjust this as needed ***********
#SBATCH --ntasks-per-node=1  # Adjust this as needed ***********
#SBATCH --time=20:00:00   # Time limit
#SBATCH --array=1    # Number of files to process (adjust this to your needs) ***********

# conda activate bcftools
sample="A_FKRN"
output_folder=/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/gatk/${sample}/
ref="/mainfs/scratch/lb3e23/Resources/GRch38/GRCh38.primary_assembly.genome.fa"
input_vcf="/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/gatk/A_FKRN/A_FKRN_variantFiltered.vcf"

bcftools filter -i 'FORMAT/DP[0] >= 8 && FORMAT/GQ[0] >= 16 && FORMAT/FS[A_FKRN:0] <= 30 && INFO/DP >= 2 && FILTER="PASS"' \
    "$input_vcf" \
    -Ov -o "${output_folder}A_FKRN_bcftools_filtered.vcf"


