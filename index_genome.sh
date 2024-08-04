#!/bin/bash
#SBATCH -J GenomeIndex     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1 # Adjust this as needed ***********
#SBATCH --time=5:00:00   # Time limit

# Load samtools
module load samtools/1.14

cd "/mainfs/scratch/lb3e23/Resources/GRch38/"
genome="/mainfs/scratch/lb3e23/Resources/GRch38/GRCh38.primary_assembly.genome.fa"

samtools faidx "${genome}"