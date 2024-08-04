#!/bin/bash

input_file="input_paths.txt"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file not found: $input_file"
    exit 1
fi

# Read each line from the input file and create a text file with the path
while IFS= read -r path; do
    # Extract the filename from the path
    filename=$(basename "$path")

    # Create a new text file with the extracted filename
    echo "$path" > "${filename}.txt"
done < "$input_file"
