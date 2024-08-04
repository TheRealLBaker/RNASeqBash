#!/bin/bash
#SBATCH -J star_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6 # Adjust this as needed
#SBATCH --time=2:00:00   # Time limit
#SBATCH --array=1-3      # Number of files to process (adjust this to your needs)

# Need to remember to delete --outTmpDir directories
# Load the STAR module
module load STAR

# Specify the directory containing your compressed FASTQ files
fastq_dir="/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1"

# Specify the path to your STAR index directory
star_index="/mainfs/scratch/lb3e23/GRch38/NewV44ref"

# Specify where you want to store the results
out_Dir="/mainfs/scratch/lb3e23/Day1/2passAlignment"

# List of files (pair filenames) - note that you need to adapt to filenames of directory
file_list=(
    "/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1/R0D1_1.fq.gz" "/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1/R0D1_2.fq.gz" "/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1/R8D1_1.fq.gz" "/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1/R8D1_2.fq.gz" "/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1/R9D1_1.fq.gz" "/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1/R9D1_2.fq.gz"
)

# Create a unique temporary directory for each job
outTmpDir="/mainfs/scratch/lb3e23/Day1/2passAlignment/temp/${SLURM_ARRAY_TASK_ID}" # Create a new directory for each slurm job, using the job id as an identifier

echo "SLURM_ARRAY_TASK_ID: ${SLURM_ARRAY_TASK_ID}"
echo "Input files: ${file_list[$((SLURM_ARRAY_TASK_ID * 2 - 2))]} ${file_list[$((SLURM_ARRAY_TASK_ID * 2 - 1))]}"

# Run STAR alignment with compressed input
STAR --outTmpDir "${outTmpDir}" \
    --genomeDir "${star_index}" \
    --readFilesCommand zcat \
    --readFilesIn "${file_list[$((SLURM_ARRAY_TASK_ID * 2 - 2))]}" "${file_list[$((SLURM_ARRAY_TASK_ID * 2 - 1))]}" \
    --outFileNamePrefix "${out_Dir}/$(basename "${file_list[$((SLURM_ARRAY_TASK_ID * 2 - 2))]}" .fq.gz)_alignment_" \
    --runThreadN 6 \
    --twopassMode Basic --twopass1readsN -1 --outSAMmapqUnique 60 \
    --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 3 --outFilterMismatchNmax 999 --outFilterMismatchNoverReadLmax 0.04 \
    --alignIntronMin 20 --alignIntronMax 1000000 --limitSjdbInsertNsj 2000000 --alignMatesGapMax 1000000
