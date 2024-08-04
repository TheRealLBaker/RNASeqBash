#!/bin/bash
#SBATCH -J picard_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=35 # Adjust this as needed ***********
#SBATCH --time=16:00:00   # Time limit


## Modules & Program paths
# java='/home/lb3e23/java/jre1.8.0_231/bin/java'
# picard_jar='/local/software/picard-tools/2.8.3/jarlib/picard.jar'

#conda activate rseqc
module load picard/2.18.14
module load R/4.0.0

# Note differences between this script and Jelmers' **********************
# Picard is set up correctly in Iridis 5 so you can just call `picard` rather than doing `java -jar picard.jar`

## File organisation
project="rnaseq"
sample="R8D1"

## Genebody coverage - make sure you are in the rseqc conda environment
geneBody_coverage.py -i /scratch/lb3e23/analysed/$project/alignment/$sample/$sample.sorted.bam -r "/mainfs/scratch/lb3e23/Resources/GRch38/gencodeV44_v1.bed" -o /scratch/lb3e23/analysed/$project/Picard/$sample

#Junction saturation and annotation
# This is part of the RSeQC toolkit. All the .py files can be found in the ./bin directory for your conda environment where you installed RseQC.
# This is what each of the flags do: -i is the input (bam), -o is the output directory, -r is the reference annotation
junction_saturation.py -i /scratch/lb3e23/analysed/$project/alignment/$sample/$sample.sorted.bam -o /scratch/lb3e23/analysed/$project/Picard/$sample -r "/mainfs/scratch/lb3e23/Resources/GRch38/gencodeV44_v1.bed"
junction_annotation.py -i /scratch/lb3e23/analysed/$project/alignment/$sample/$sample.sorted.bam -o /scratch/lb3e23/analysed/$project/Picard/$sample -r "/mainfs/scratch/lb3e23/Resources/GRch38/gencodeV44_v1.bed"
