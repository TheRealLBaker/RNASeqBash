#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1 # Adjust this as needed
#SBATCH --time=2:00:00   # Time limit

# Ensure you are in the correct conda environment
source activate rnaCount

# Run htseq-count on selected BAM files using the GTF annotation file 
htseq-count --format=bam --order=pos --stranded=reverse --type=exon -i gene_id -m intersection-strict "/mainfs/scratch/lb3e23/GRch38/Day1BAM/Day1PatientTest_sorted.bam" "/mainfs/scratch/lb3e23/GRch38/gencode.v29.annotation.gtf" > counts.txt