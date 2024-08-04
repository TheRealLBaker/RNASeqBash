#!/bin/bash
# Activate conda environment
#conda activate bedTools

# Change file paths and names appropriately. The lines marked with "**********************" are ones that need changing.
# Declare location for reference and output
ref="/mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.chr_patch_hapl_scaff.annotation.gtf"
output_dir="/mainfs/scratch/lb3e23/Resources/Exons/chr3" #***************
output_file="chr3.only_exons.gencode.v44.annotation.gtf.txt" #*****************

# Check if the reference file exists
if [ ! -f "$ref" ]; then
    echo "Reference file not found: $ref"
    exit 1
fi

# Check if the output directory exists, create if not
mkdir -p "$output_dir"

bedtools intersect -a $ref -b <(echo -e "chr3\t0\t100000000\tExon") > "$output_dir/$output_file" #*******************
echo "Done"

# Cut out only the necessary bits to keep
cut -f 1,3-5 "$output_dir/$output_file" > "$output_dir/cut_$output_file"

# Select only exons 
awk -F'\t' '$2 == "exon" {print $1, $3, $4, $5}' "$output_dir/cut_$output_file" > "$output_dir/filtered_cut_$output_file" 
#-F'\t': Specifies the input field separator as a tab (\t)
#$2 == "exon": Checks if the second column is equal to "exon."
#{print $1, $3, $4, $5}: If the condition is true, it prints the first, third, fourth, and fifth columns.
#awk is a powerful text processing tool, awk reads input data line by line and allows you to specify patterns that define which lines to process
#For lines that match the specified patterns, awk performs actions.
#awk breaks each line into fields based on a delimiter (by default, space or tab). You can refer to fields using $1, $2, etc., to represent the first, second, and subsequent fields in a line.
