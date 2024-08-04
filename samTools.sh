#!/bin/bash
#SBATCH -J star_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=19 # Adjust this as needed ***********
#SBATCH --time=20:00:00   # Time limit
#SBATCH --array=1    # Number of files to process (adjust this to your needs) ***********

# Load samtools
module load samtools/1.14

# Go to directory containing bam files
cd /mainfs/scratch/lb3e23/analysed/rnaseq/batch4/STAR/no_47_FKRN220304335-1A_H22CMDSX5_L2/
## SamTools script
samtools sort ./Aligned.out.bam > ./${sample[${SLURM_ARRAY_TASK_ID} - 1]}.sorted.bam
samtools index ./no_47_FKRN220304335-1A_H22CMDSX5_L2.sorted.bam

# If index is successfully created, sort should have also been completed successfully; can then remove the initial unsorted file.
if [ -f "./$sample.sorted.bam.bai" ]; then
	rm ./Aligned.out.bam
fi
