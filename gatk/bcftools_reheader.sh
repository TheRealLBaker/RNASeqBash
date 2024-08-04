#!/bin/bash
#SBATCH -J gatk_DC_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1 # Adjust this as needed ***********
#SBATCH --time=20:00:00   # Time limit
#SBATCH --array=1    # Number of files to process (adjust this to your needs) ***********

# conda activate bcftools

bcftools annotate --rename-chrs <(tail -n+2 rename_chrs.txt) "/mainfs/scratch/lb3e23/Resources/GRch38/snpVCF/dbSNP/00-All.vcf" > "/mainfs/scratch/lb3e23/Resources/GRch38/snpVCF/dbSNP/reheader_00-All.vcf"
