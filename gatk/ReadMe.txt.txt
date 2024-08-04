The GATK workflow should run the scripts in this directory in the following sequence:

===============================================================================================================================
1. gatkDataCleanUp.sh
2. gatkSplitNcigar.sh
3. gatkAnalyzeCovariates.sh
4. gatkAddOrReplaceReadGroups.sh
5. gatkBaseRecalibration.sh
6. gatkApplyBQSR.sh
7. gatkHaplotypeCaller.sh
8. gatk_variantFiltering.sh
9. bcftoolsFiltering.sh
10. vepAnnotation.sh
11. spliceaiBatch.sh

=================================================================================================================================
gatkCombinedPt1.sh Combines scripts 1-10 into a single script. When adding more scripts to this combined script, need to bare in mind
the following:

- Need to initialize conda at least once to load conda modules into the current shell session in the batch `eval "$(conda shell.bash hook)"`
- Load and unload modules after each command if necessary. The presence of certain modules can clash with other modules and dependencies.


==================================================================================================================================


Caveats:

1. For gatkBaseRecalibration.sh, you need a VCF for all the known SNPs and Indels in the genome 
that you are working with. Multiple VCF can be submitted for the --known-sites option. The one
used here is from dbSNP, version is human_9606_b151_GRCh38p7. With some VCF, the #CHROM column 
list chromosomes as number (1,2,3...) and others list it as chr number (chr1, chr2, chr3...)
Need to standardise according to your genome index, which uses chr number.

2. To convert number into chr number, the following awk command can be used:
awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' "/mainfs/scratch/lb3e23/Resources/GRch38/snpVCF/dbSNP/00-All.vcf" > "/mainfs/scratch/lb3e23/Resources/GRch38/snpVCF/dbSNP/chr_00-All.vcf"
The input (first path) and output file (second path) should be adjusted to the paths of your choice.

3. gatk_variantFiltering does not remove variants that doesn't meet the filtering criteria, it adds a filter column, where those that meets it is labelled "PASS".
The ones that do not meet it get the name of the --filter-name that you entered. "This tool is designed for hard-filtering variant calls based on certain criteria. Records are hard-filtered by changing the value in the FILTER field to something other than PASS. Filtered records will be preserved in the output unless their removal is requested in the command line."

4. The meaning of the symbols in the fields (e.g., GQ, DP, etc) are found in VCFv4.3_termsUsedInVCFfiltering.pdf. 

5. bcftools can filter out anything you set the condition to; can also filter out the retained filters from the gatk_variantFiltering. All 
variants that do not have the FILTER="PASS" can be filtered out using bcftools so that the entry no longer remains in the column.

6. Activate the conda environment `spliceai` but do not activate python virtual environment. Run `spliceai1.sh` which runs the python script
`spliceaiAnalysis.py`

7. The output file from vepAnnotation.sh is not a vcf file. The header is not right. Can check whether a file is vcf by using `bcftools view -h path/path/path`
if you run the vep command with the --vcf option, it will output a vcf file in the correct format.

8. To install the cache for homo_sapiens as required:
vep_install -a cf -s homo_sapiens -y GRCh38 -c /mainfs/scratch/lb3e23/cache/vep/ --CONVERT

9. To run spliceai, `conda activate spliceai`, in terminal or batch script write `python -m spliceai [-h] [-I [input]] [-O [output]] -R reference -A annotation
                   [-D [distance]] [-M [mask]]` with the parameters for each entered. The location of the spliceai module is: "/mainfs/scratch/lb3e23/.conda/envs/spliceai/bin/
spliceai"
The .conda directory is hidden, need to do `ls -a` and cd through each layer. Typing `which spliceai` in terminal after conda activation which tell you where it is located.


***Notes:

- spliceai1.sh uses spliceaiAnalysis.py. spliceaiAnalysis.py imports spliceai and tries to utilise the spliceai.utils classes and functions.
However, the __main__.py already does this in a way that works so these two scripts are redundant. Run spliceaiBatch.sh instead, after activating
the spliceai conda environment.

- For a single CPU core, spliceai does around 4000 reads per hour. So setting CPU core = 10 means it does 40,000 lines an hour. Not quite, it is less
than this: https://github.com/Illumina/SpliceAI/issues/20
Should look into using GPU computing, much faster for this.

- Also, spliceaiBatch.sh should be ran on GPU partition, otherwise certain tensorflow libraries are not available, get the following message:
"W tensorflow/stream_executor/platform/default/dso_loader.cc:64] Could not load dynamic library 'libcuda.so.1'; dlerror: libcuda.so.1: cannot open shared object file: No such file or directory; LD_LIBRARY_PATH: /local/software/slurm/default/lib:"






