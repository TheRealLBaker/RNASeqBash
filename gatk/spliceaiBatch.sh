#!/bin/bash
#SBATCH -J spliceAI_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1 # Adjust this as needed ***********
#SBATCH --ntasks-per-node=1  # Adjust this as needed ***********
#SBATCH --time=20:00:00   # Time limit
#SBATCH --array=1    # Number of files to process (adjust this to your needs) ***********

# conda activate spliceai

# Variables declaration
input="/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/gatk/A_FKRN/new_A_FKRN_vep_filtered.vcf"
output="/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/gatk/A_FKRN/A_FKRN_spliceAI.vcf"
genome="/mainfs/scratch/lb3e23/Resources/GRch38/GRCh38.primary_assembly.genome.fa"
annotation="/mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.annotation.gtf"

# SpliceAI command
python -m spliceai -I $input -O $output -R $genome -A $annotation -D 500