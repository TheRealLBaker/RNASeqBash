#!/bin/bash
#SBATCH -J convertToBED   # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16 # Adjust this as needed ***********
#SBATCH --time=6:00:00   # Time limit

# Small job, can be done in terminal without use of batch scripting.

# activate environment
conda activate bedops

# declare variables

gtf="Path to reference GTF or GFF3 file"
output="Path to file to be outputted"

# Use bedops instead, it is a much easier and better tool.

gtf2bed < $gtf > $output


