#!/bin/bash
#SBATCH -J FastQC_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6 # Adjust this as needed
#SBATCH --time=4:00:00   # Time limit
#SBATCH --array=1-6      # Number of files to process (adjust this to your needs)

#Load FastQC
module load fastqc

# Go to the FastQC program location
cd /local/software/fastqc/0.11.9/FastQC/

# Specify the directory containing your compressed FASTQ files
fastq_dir="/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1"

# Specify where you want to store the results
out_Dir="/mainfs/scratch/lb3e23/GRch38/FastQCoutput/Day1"

# Get the file list from a text file (e.g., files.txt)
file_list="/mainfs/scratch/lb3e23/GRch38/file_list.txt"
input_file=$(sed -n "$SLURM_ARRAY_TASK_ID"p "$file_list")

#Run fastqc on selected files
fastqc "${fastq_dir}/${input_file}" --outdir="$out_Dir"