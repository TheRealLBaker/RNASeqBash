#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1 # Adjust this as needed
#SBATCH --time=2:00:00   # Time limit

#Load SamTools
module load samtools

#Go to BAM directory
cd "/mainfs/scratch/lb3e23/GRch38/Day1_alignment_1file"
samtools view -bS _alignment_Aligned.out.sam -o Day1PatientTest.bam