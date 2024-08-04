eval "$(conda shell.bash hook)"
conda activate samtools
bam_path=""
region=""
output=""
output_fasta=""
samtools view -b ${bam_path} ${region} > ${output}
samtools fasta ${output} > ${output_fasta}