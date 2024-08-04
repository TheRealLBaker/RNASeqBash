#!/bin/bash

# Directory containing your .fq.gz files
input_directory="/mainfs/scratch/lb3e23/HarddriveB/TimepointsNasalBrushingsAndALIculture/ALI_day_1/"

# Create an output text file to store the list of file names
output_file="file_list.txt"

# Use the find command to search for .fq.gz files in the directory
#find "$input_directory" -type f -name "*.fq.gz" > "$output_file" This is for full directory
#find "$input_directory" -name "*.fq.gz" -exec basename {} \; > "$output_file" # This is for basename with extension
find "$input_directory" -name "*.fq.gz" -exec basename {} \; | sed 's/\..*//' > "$output_file" # This is for basename
echo "List of .fq.gz files saved to $output_file"