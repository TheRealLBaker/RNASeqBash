import pandas as pd
import subprocess
import argparse
import os

def main(file_path, sample, vcf_path):
    # Load the Excel files
    df = pd.read_excel(file_path)
    vcf = pd.read_csv(vcf_path)

    # Directory path
    output_dir = f"/mainfs/scratch/lb3e23/ggSashimi/test/output/{sample}/"
    
    # Create the directory if it does not exist
    os.makedirs(output_dir, exist_ok=True)

    # relevant columns of vcf
    chrom = vcf['CHROM']
    position = vcf['POS']

    # Iterate through each row and construct the bash command
    for index, row in df.iterrows():
        # relevant columns of excel file
        gene_symbol = row['geneSymbol']
        genomic_coord1 = row['genomicLocation']
        genomic_coord2 = row['genomicLocation2']

        if pd.isna(genomic_coord2):
            coord = genomic_coord1
        else:
            coord = f"{genomic_coord1.split('-')[0]}-{genomic_coord2.split('-')[1]}"

        # create filtered data frame for variant - first, keep only entries that match the variant chromosome
        chrom_value = genomic_coord1.split(':')[0]
        vcf_df = vcf[vcf['CHROM'] == chrom_value]
        
        upper = int(coord.split(':')[1].split('-')[1]) + 500
        lower = int(coord.split(':')[1].split('-')[0]) - 500
        
        filtered_vcf_df = vcf_df[(vcf_df['POS'] >= lower) & (vcf_df['POS'] <= upper)]
        pos_values = filtered_vcf_df['POS'].tolist()

        if len(pos_values) <= 0:
            # Variant coordinate functionality not implemented just yet, just set variant coordinate to the same as the start of genomic_coord1
            var_coord = genomic_coord1.split(':')[1].split('-')[0]
        elif len(pos_values) == 1:
            var_coord = pos_values[0]
        else:
            var_coord = pos_values[0]
            for i in pos_values:
                print(f"{i}\t")

        # Construct the bash command
        bash_command = (
            f"python /mainfs/scratch/lb3e23/ggSashimi/ggsashimi/ggsashimi.py "
            f"-b input.tsv -c {coord} "
            f"-g /mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.annotation.gtf "
            f"-PL {sample} -V {var_coord} -M 1 -C 3 -O 3 --alpha 0.25 --base-size=20 --ann-height=2 "
            f"--height=3 --width=18 -P /mainfs/scratch/lb3e23/ggSashimi/test/palette.txt "
            f"-o {output_dir}{gene_symbol}_{index}"
        )

        # Run the bash command
        subprocess.run(bash_command, shell=True)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run ggsashimi commands based on Excel input")
    parser.add_argument("file_path", help="Path to the Excel file")
    parser.add_argument("sample_name", help="Name of the sample")
    parser.add_argument("vcf_path", help="Path to the VCF file")
    
    args = parser.parse_args()
    
    main(args.file_path, args.sample_name, args.vcf_path)
