#!/bin/bash
# Activate conda environment
# conda activate bedTools

# Change file paths and names appropriately. The lines marked with "**********************" are ones that need changing.
# Declare location for reference and output
ref="/mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.chr_patch_hapl_scaff.annotation.gtf"
output_root="/mainfs/scratch/lb3e23/Resources/Exons" #***************

# Check if the reference file exists
if [ ! -f "$ref" ]; then
    echo "Reference file not found: $ref"
    exit 1
fi

# Loop through chromosomes 4 to 22
for chr in {1..22}; do
    # Output directory and file names
    output_dir="$output_root/chr${chr}"
    output_file="chr${chr}.only_exons.gencode.v44.annotation.gtf.txt"

    # Check if the output directory exists, create if not
    mkdir -p "$output_dir"

    # bedtools intersect
    bedtools intersect -a "$ref" -b <(echo -e "chr${chr}\t0\t100000000\tExon") > "$output_dir/$output_file"

    # cut
    cut -f 1,3-5 "$output_dir/$output_file" > "$output_dir/cut_$output_file"

    # awk
    awk -F'\t' '$2 == "exon" {print $1, $3, $4, $5}' "$output_dir/cut_$output_file" > "$output_dir/filtered_cut_$output_file"

    echo "Processing for chr${chr} is done"
done
