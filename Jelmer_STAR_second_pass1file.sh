#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6 # Adjust this as needed
#SBATCH --time=2:00:00   # Time limit

# Load the STAR module
module load STAR

# Go to the location of the STAR program
cd /local/software/star/STAR_2.7.10a/STAR

# Specify the directory containing your compressed FASTQ files
fastq_dir="/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1"

# Specify the path to your STAR index directory
star_index="/mainfs/scratch/lb3e23/GRch38/V44ref"

# Specify where you want to store the results
out_Dir="/mainfs/scratch/lb3e23/GRch38/Day1_alignment_1file"


# Run STAR alignment with compressed input
STAR --genomeDir "${star_index}"\
    --readFilesCommand zcat \
    --readFilesIn "/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1/R0D1_1.fq.gz" "/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1/R0D1_2.fq.gz"\
    --outFileNamePrefix "${out_Dir}/${input_file%.fq.gz}_alignment_" \
    --runThreadN 6 \
    --twopassMode Basic --twopass1readsN -1 --outSAMmapqUnique 60 \
    --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 3 --outFilterMismatchNmax 999 --outFilterMismatchNoverReadLmax 0.04 \
    --alignIntronMin 20 --alignIntronMax 1000000 --limitSjdbInsertNsj 2000000 \
    --alignMatesGapMax 1000000