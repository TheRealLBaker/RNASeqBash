find /mainfs/scratch/lb3e23/analysed/rnaseq/alignment/HarddriveA/non_PCD_patients_analysed/ALI_day21/ -type f -name "Aligned.out.bam" -exec rm {} \;

#find: Starts the find command
#/mainfs/scratch/lb3e23/analysed/rnaseq/alignment/HarddriveA/non_PCD_patients_analysed/ALI_day21/: Specifies the starting directory for the search.
#-type f: Restricts the search to files (not directories).
#-name "Aligned.out.bam": Specifies the name of the file to search for.
#-exec rm {} \;: Executes the rm command on each file found. The {} is a placeholder for the current file, and \; marks the end of the -exec option.

find /mainfs/scratch/lb3e23/analysed/rnaseq/alignment/HarddriveA/non_PCD_patients_analysed/ALI_day21/ -type f -name "Aligned.out.bam" -exec rm -i {} \;
#If you want to confirm before each deletion, you can use the -i option with rm