#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2 # Adjust this as needed
#SBATCH --time=2:00:00   # Time limit
#SBATCH --array=1-3   # Adjust this to match the number of SAM files
#SBATCH --output=sortBAM_%A_%a.out

#Load samtools
module load samtools

# Set the input directory containing your BAM files
input_dir="/mainfs/scratch/lb3e23/Day1/UnsortedBAM"

# Set the output directory for sorted BAM files
output_dir="/mainfs/scratch/lb3e23/Day1/SortedBAM"

#Set up temporary directory
temp_dir="/mainfs/scratch/lb3e23/Day1/SortedBAM/${SLURM_ARRAY_TASK_ID}"

# Make sure the output directory exists
mkdir -p "$output_dir"

# Loop through the BAM files in the input directory
for bam_file in "$input_dir"/*.bam; do
    # Check if the file is a regular file (not a directory)
    if [ -f "$bam_file" ]; then
        # Extract the file name without extension
        file_name=$(basename "$bam_file" .bam) # basename is the function that takes the last part of the file path. The second argument, .bam, is the file extension that you would like to remove.
        
        # Sort the BAM file and save it in the output directory
        samtools sort -T "$temp_dir" "$bam_file" -o "$output_dir/${file_name}_sorted.bam" #Use samtools to sort the bam file and output it to our desired directory, with the appropriate file name.
        
        # Index the sorted BAM file
        samtools index "$output_dir/${file_name}_sorted.bam" # Index our sorted bam files.
        
        echo "Sorted and indexed: ${file_name}.bam" # Lets us know it has happened.
    fi
done