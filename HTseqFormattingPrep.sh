# Need to ensure the headers of the GTF and the BAM sorted files are in the same format. Otherwise won't count properly and all genes will have 0 reads.
# cp your_sorted.bam your_sorted_original.bam || creates backup of BAM files
# samtools view -H your_sorted.bam | sed 's/SN:/SN:chr/' | samtools reheader - your_sorted.bam > your_sorted_with_chr.bam || adds the chr prefix

# Check the headers of BAM and GTF to make sure that it is the same now. 
# For checking BAM
samtools view -H your_sorted.bam
# For checking annotation
head annotation.GTF