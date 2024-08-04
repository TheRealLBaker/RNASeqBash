#!/bin/bash
#SBATCH -J featureCounts_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1 # Adjust this as needed ***********
#SBATCH --time=40:00:00   # Time limit
#SBATCH --array=1-10

# Activate conda environment
eval "$(conda shell.bash hook)"
conda activate featurecounts
# Specify location of files
GTF="/mainfs/scratch/lb3e23/Resources/GRch38/gencode.v44.annotation.gtf"
file_list="/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/STAR_sjdboverhang/samples.txt"
input_file=$(awk "NR==$SLURM_ARRAY_TASK_ID" "$file_list" | tr -d '[:space:]') # awk starts with 1 rather than 0
echo $input_file

base_directory=/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/STAR/
patient=$(find "$base_directory" -mindepth 1 -maxdepth 3 -type f -name "${input_file}*.sorted.bam")
out_dir="/mainfs/scratch/lb3e23/analysed/rnaseq/batch4/STAR/featureCounts/${input_file}"
mkdir $out_dir
cd $out_dir
echo ${patient}
# featureCounts command
featureCounts -a ${GTF} -o "./${input_file}_fragmentCounts.txt" -p --countReadPairs ${patient}

featureCounts -a ${GTF} -o "./${input_file}_readCounts.txt" -p ${patient}