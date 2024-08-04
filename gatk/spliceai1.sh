#!/bin/bash

#SBATCH -J spliceAI_array     # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --array=1
 
module load conda
conda activate spliceai
 
python spliceai.py