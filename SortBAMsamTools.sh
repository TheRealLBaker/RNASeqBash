#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2 # Adjust this as needed
#SBATCH --time=2:00:00   # Time limit

#Load samtools
module load samtools

# Set the input directory containing your BAM files
input_dir="/mainfs/scratch/lb3e23/GRch38/Day1_alignment_1file/"

# Set the output directory for sorted BAM files
output_dir="/mainfs/scratch/lb3e23/GRch38/Day1BAM"

# Make sure the output directory exists
mkdir -p "$output_dir"

# Loop through the BAM files in the input directory
for bam_file in "$input_dir"/*.bam; do
    # Check if the file is a regular file (not a directory)
    if [ -f "$bam_file" ]; then
        # Extract the file name without extension
        file_name=$(basename "$bam_file" .bam) # basename is the function that takes the last part of the file path. The second argument, .bam, is the file extension that you would like to remove.
        
        # Sort the BAM file and save it in the output directory
        samtools sort "$bam_file" -o "$output_dir/${file_name}_sorted.bam" #Use samtools to sort the bam file and output it to our desired directory, with the appropriate file name.
        
        # Index the sorted BAM file
        samtools index "$output_dir/${file_name}_sorted.bam" # Index our sorted bam files.
        
        echo "Sorted and indexed: ${file_name}.bam" # Lets us know it has happened.
    fi
done