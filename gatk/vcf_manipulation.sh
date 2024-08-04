# Variable setting
input="sample.vcf"
ouput="sample.vcf"
# Remove header
grep -v '^#' $input > $output
# Add columns to the vcf
echo -e "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tA_FKRN" > 50line_header.vcf
cat 50line.vcf >> 50line_header.vcf # the header file is the file containing the hearder and the rest of the content
# Extract only the INFO column
awk '{print $8}' 50line_header.vcf > 50line_header_info.vcf

# Separate each field from the INFO column
awk -F"\t" '{split($8, fields, "|"); for (i=1; i<=length(fields); i++) { if (fields[i] == "") { printf "\"\"\t" } else { printf "%s\t", fields[i] } } printf "\n" }' 50line_header.vcf > info_columns.tsv



