#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --array=1-3   # Adjust this to match the number of SAM files
#SBATCH --output=convert_sam_to_bam_%A_%a.out

# Load SamTools
module load samtools

# Directory where SAM files are located
sam_dir="/mainfs/scratch/lb3e23/Day1/2passAlignment/"

# Directory where you want to save the BAM files
bam_dir="/mainfs/scratch/lb3e23/Day1/UnsortedBAM/"

# Create the output directory if it doesn't exist
mkdir -p "$bam_dir"

# Get the list of SAM files
sam_files=("$sam_dir"/*.sam)

# Get the index (array task ID) to select the SAM file
index=$((SLURM_ARRAY_TASK_ID - 1))
sam_file="${sam_files[$index]}"

if [ -n "$sam_file" ]; then # [ -n "$sam_file" ]: This is the condition being tested. It checks whether the variable $sam_file is non-empty.

    # Generate the output BAM file name by replacing .sam with .bam
    bam_file="$bam_dir/$(basename "${sam_file%.sam}.bam")"
    
    # Convert SAM to BAM
    samtools view -bS "$sam_file" -o "$bam_file"
    
    echo "Converted $sam_file to $bam_file"
else
    echo "No more SAM files to process."
fi
