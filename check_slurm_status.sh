#!/bin/bash

# Define the directory to search
search_dir="/path/to/your/directory"

# Change directory to the search directory
cd "$search_dir" || exit

# Iterate through slurm output files
for file in slurm-*.out; do
    # Check if the file exists and is a regular file
    if [ -f "$file" ]; then
        # Check if the file contains the "State:" section
        if grep -q "State:" "$file"; then
            # Extract the status and the associated exit code
            status=$(grep "State:" "$file" | sed -n 's/.*State: \(.*\) (exit code \([0-9]*\)).*/\1/p')
            exit_code=$(grep "State:" "$file" | sed -n 's/.*State: \(.*\) (exit code \([0-9]*\)).*/\2/p')
            # Check if the status is not "COMPLETED" or the exit code is not 0
            if [ "$status" != "COMPLETED" ] || [ "$exit_code" != "0" ]; then
                # Rename the file by adding "Incomplete", the status, and the exit code to the beginning of the file name
                mv "$file" "Incomplete_${status}_${exit_code}_${file}"
                echo "$file has status: $status (exit code $exit_code). Renamed to Incomplete_${status}_${exit_code}_${file}"
            else
                # If the status is "COMPLETED" and the exit code is 0, skip the file
                echo "$file is completed and exited with code 0. Skipping."
            fi
        else
            # If the "State:" section is not found, append "Incomplete_blank" to the beginning of the file name
            mv "$file" "Incomplete_blank_${file}"
            echo "$file does not contain the expected structure. Renamed to Incomplete_blank_${file}"
        fi
    fi
done
