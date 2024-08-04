#!/bin/bash

# Prompt the user to enter the sample directory
echo "Enter the sample directory:"
read sample_dir

# Define the base directory
baseMajiq="/mainfs/scratch/lb3e23/analysed/rnaseq/batch5/MAJIQ/${sample_dir}/build/"

# Initialize an array to store the file paths
file_paths=()

# Loop through numbers 1 to 31 and construct the file paths
for ((i = 1; i <= 31; i++)); do
    file_paths+=("${baseMajiq}N${i}.sorted.majiq")
done

# Output the file paths separated by spaces and save to an output file
echo "${file_paths[@]}" > "${sample_dir}_deltaPsi.txt"
