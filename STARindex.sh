#!/bin/bash
#SBATCH --ntasks=30
#SBATCH --cpus-per-task=1  # Use 1 CPU core per task
#SBATCH --nodes=1
#SBATCH --time=04:00:00

mkdir /mainfs/scratch/lb3e23/GRch38/V44ref/
 
cd /local/software/star/STAR_2.7.10a/

./STAR --runThreadN 30 --runMode genomeGenerate --genomeDir "/mainfs/scratch/lb3e23/Resources/GRch38/NewV44refV1/" --genomeFastaFiles "/mainfs/scratch/lb3e23/Resources/GRch38/GRCh38.p13.genome.fa" --sjdbGTFfile "/mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.annotation.gtf" --outFileNamePrefix "/mainfs/scratch/lb3e23/Resources/GRch38/NewV44refV1/log"