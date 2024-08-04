#!/bin/bash

# Define the directory to search
search_dir="/mainfs/scratch/lb3e23/analysed/rnaseq/batch5/HTseq/"

# Change directory to the search directory
cd "$search_dir" || exit

# Iterate through subdirectories
for dir in */; do
    # Check if the directory contains any .txt files that are empty/0 KB
    if [[ -n $(find "$dir" -maxdepth 1 -type f -name "*.txt" -size 0) ]]; then
        # Delete empty .txt files
        find "$dir" -maxdepth 1 -type f -name "*.txt" -size 0 -delete
        # Rename the subdirectory by appending "incomplete"
        mv "$dir" "${dir%?}_incomplete"
    fi
done
