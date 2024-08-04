#!/bin/bash
#SBATCH -J Vep_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1 # Adjust this as needed ***********
#SBATCH --ntasks-per-node=1  # Adjust this as needed ***********
#SBATCH --time=20:00:00   # Time limit
#SBATCH --array=1    # Number of files to process (adjust this to your needs) ***********

#conda activate vep

genome="/mainfs/scratch/lb3e23/Resources/GRch38/GRCh38.primary_assembly.genome.fa"
annotation="/mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.annotation.gtf"
cache="/mainfs/scratch/lb3e23/cache/vep/"
input="/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/gatk/A_FKRN/A_FKRN_bcftools_filtered.vcf"
output="/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/gatk/A_FKRN/new_A_FKRN_vep_filtered.vcf"
vep -i $input -o $output \
    --cache --dir_cache $cache \
    --vcf --offline \
    --fasta $genome --distance 5000 --nearest gene \
	--fork 1
