conda activate samtools
samtools view -H no_43_FKRN220304333-1A_H22FNDSX5_L4_2.fq.gz.sorted.bam > header.sam

# Filter NH > 20
samtools view no_43_FKRN220304333-1A_H22FNDSX5_L4_2.fq.gz.sorted.bam | awk '$0 ~ /NH:i:[2-9][0-9]+/ || $0 ~ /NH:i:[0-9]{3,}/' > no43_multimap.sam
cat header.sam no43_multimap.sam > no43_multimap_cat.sam
samtools view -Sb no43_multimap_cat.sam > no43_multimap_cat.bam
# Sort the bam files
samtools sort no43_multimap_cat.bam > no43_multimap_cat.sorted.bam
# Index the sorted BAM file (optional but recommended for downstream processing)
samtools index no43_multimap_cat.sorted.bam

conda activate bedTools
bedtools bamtofastq -i no43_multimap_cat.bam -fq no43_multimap_cat_1.fastq -fq2 no43_multimap_cat_2.fastq