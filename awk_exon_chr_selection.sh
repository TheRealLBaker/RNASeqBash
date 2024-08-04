#!/bin/bash
# Change file paths and names appropriately. The lines marked with "**********************" are ones that need changing.
# Declare location for reference and output
ref="/mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.annotation.gtf"
output_root="/mainfs/scratch/lb3e23/Resources/awkExons" #***************

# Check if the reference file exists
if [ ! -f "$ref" ]; then
    echo "Reference file not found: $ref"
    exit 1
fi

# Loop through chromosomes 1 to 22
for chr in {1..22}; do
    # Output directory and file names
    output_dir="$output_root/chr${chr}"
    output_file="chr${chr}.only_exons.gencode.v44.annotation.gtf.txt"

    # Check if the output directory exists, create if not
    mkdir -p "$output_dir"
    cd "$output_dir" || exit 1  # Exit if unable to change directory

    # Use awk to filter exons and extract relevant columns
    awk -v chromosome="$chr" '$3 == "exon" && $1 == "chr" chromosome {print $1, $4, $5}' \
        "/mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.annotation.gtf" > "$output_file"

    echo "Processing for chr${chr} is done"
done

# Loop through chromosomes M, X, and Y
for chr in "M" "X" "Y"; do
    # Output directory and file names
    output_dir="$output_root/chr${chr}"
    output_file="chr${chr}.only_exons.gencode.v44.annotation.gtf.txt"

    # Check if the output directory exists, create if not
    mkdir -p "$output_dir"
    cd "$output_dir" || exit 1  # Exit if unable to change directory

    # Use awk to filter exons and extract relevant columns
    awk -v chromosome="$chr" '$3 == "exon" && $1 == "chr" chromosome {print $1, $4, $5}' \
        "/mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.annotation.gtf" > "$output_file"

    echo "Processing for chr${chr} is done"
done


#awk '$3 == "exon"' "/mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.annotation.gtf" > exon_filtered.gtf
#awk '{print $1, $4, $5}' exon_filtered.gtf > 3col_exon_filtered.gtf
#awk '$1 == "chr1" && $3 == "exon" {print $1, $4, $5}' exon_filtered.gtf > exon_filtered_chr1.gtf
