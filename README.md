
### **How to run this code**

In this repository, all scripts used in this project are in a folder /scripts. There are sub folders of /scripts, that correspond to the steps in the handout. Further information below to reproduce exact steps

### FOR ALL SCRIPTS ENSURE THAT PATH NAMES ARE CORRECT

2. Quality checks: 
    1. run fastqc on provided fastq files
    2. run multiqc on outputted fastqc files from step 1
    3. run fastp on provided fastq files
    4. repeat step 2 with output files from step 3

3. Map reads to reference genome
    1. Run hisat2-build to generate index files for the reference genome (download from Ensemnbl)
    2. run hisat2 with the wrapper function to map reads to reference genome for each sample
    3. run samconv with wrapper function to convert .sam files to .bam, create sort the .bam files, and then create indexes for the sorted .bam files. The wrapper functions allows you to do this for each sample in parallel
    4. run check_multimap.slurm to check the occurence of multimapped reads.
    5. run samconvrmdup.slurm with samconv_wrapper to run the same steps as 3, but to remove duplicate reads before indexing .bam files.

4. Count the number of reads per gene
    1. execute featureCounts.slurm to create the feature counts matrix.
    2. execute both clean_featureCounts scripts. Make sure you create a new output file
    3. execute fractions_featureCounts script to proportions.

5. Run the r script, Statistical analysis to perform PCA, DE analysis, and overrepresentation analysis
