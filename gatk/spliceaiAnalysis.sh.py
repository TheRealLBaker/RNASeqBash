import spliceai
import pysam

# Variables declaration
input_vcf = "/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/gatk/A_FKRN/A_FKRN_vep_filtered.vcf"
output_vcf = "/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/gatk/A_FKRN/A_FKRN_spliceAI.vcf"
genome_fa = "/mainfs/scratch/lb3e23/Resources/GRch38/GRCh38.primary_assembly.genome.fa"
annotation_gtf = "/mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.annotation.gtf"

# Create an instance of the Annotator class
annotator = spliceai.Annotator(genome_fa, annotation_gtf)

# Open the VCF files
input_vcf_reader = pysam.VariantFile(input_vcf)
output_vcf_writer = pysam.VariantFile(output_vcf, 'w', header=input_vcf_reader.header)

# Iterate over the records in the input VCF file
for record in input_vcf_reader:
    # Extract relevant information from the VCF record
    chrom = record.chrom
    pos = record.pos
    ref = record.ref
    alts = record.alts

    # Compute delta scores for each alternative allele
    delta_scores = get_delta_scores(record, annotator, dist_var=500, mask=False)

    # Add the computed delta scores as annotations to the VCF record
    record.info['DeltaScores'] = delta_scores

    # Write the annotated VCF record to the output VCF file
    output_vcf_writer.write(record)

# Close the VCF files
input_vcf_reader.close()
output_vcf_writer.close()