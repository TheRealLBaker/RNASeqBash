#!/bin/bash
#SBATCH -J gatk_DC_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1 # Adjust this as needed ***********
#SBATCH --time=20:00:00   # Time limit
#SBATCH --array=1    # Number of files to process (adjust this to your needs) ***********

# conda activate gatk4

module load picard

sample="A_FKRN"
output_folder=/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/gatk/${sample}/
ref="/mainfs/scratch/lb3e23/Resources/GRch38/GRCh38.primary_assembly.genome.fa"


picard AddOrReplaceReadGroups \
       I=${output_folder}A_FKRN_cigar.bam \
       O=${output_folder}A_FKRN_addedReadGroup.bam \
       RGLB=lib1 \
       RGPL=ILLUMINA \
       RGPU=unit1 \
       RGSM=A_FKRN