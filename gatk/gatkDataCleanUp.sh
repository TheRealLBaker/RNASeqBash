#!/bin/bash
#SBATCH -J gatk_DC_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2 # Adjust this as needed ***********
#SBATCH --time=20:00:00   # Time limit
#SBATCH --array=1    # Number of files to process (adjust this to your needs) ***********

sample="A_FKRN"
output_folder=/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/gatk/${sample}/
mkdir -p output_folder

picard MarkDuplicates \
I="/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/STAR/A_FKRN220304339-1A_H22CMDSX5_L2_1.fq.gz/A_FKRN220304339-1A_H22CMDSX5_L2_1.fq.gz.sorted.bam" \
O=${output_folder}A_FKRN_marked_duplicates.bam \
M=${output_folder}A_FKRN_marked_dup_metrics.txt