#!/bin/bash

# Check if the correct number of arguments are passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <file_path1> <file_path2>"
    exit 1
fi
# Assign the arguments to variables
file_path1=$1
file_path2=$2

# Check if both files exist
if [ ! -f "$file_path1" ]; then
    echo "File $file_path1 does not exist."
    exit 1
fi

if [ ! -f "$file_path2" ]; then
    echo "File $file_path2 does not exist."
    exit 1
fi
# Find .sorted.bam files in both directories and their subdirectories and save them in arrays
mapfile -t sorted_bam_files1 < <(find "$dir_path1" -type f -name "*.sorted.bam")
mapfile -t sorted_bam_files2 < <(find "$dir_path2" -type f -name "*.sorted.bam")
# Join arrays into comma-separated strings
bamdirs1=$(IFS=,; echo "${sorted_bam_files1[*]}")
bamdirs2=$(IFS=,; echo "${sorted_bam_files2[*]}")

# Join all bam directories into one string
all_bamdirs="$bamdirs1,$bamdirs2"

# Create the output file
output_file="output.txt"
{
    echo "[info]"
    echo "bamdirs=$all_bamdirs"
    echo "genome=hg38"
    echo "strandness=reverse"
    echo "[experiments]"
    echo "Patient=${bamdirs1}"
    echo "Controls=${bamdirs2}"
} > "$output_file"
echo "Output written to $output_file"

exit 0