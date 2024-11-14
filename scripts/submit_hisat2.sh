#!/bin/bash

# Define the input directory
INPUT_DIR="/data/courses/rnaseq_course/breastcancer_de/reads"
JOB_SCRIPT="/data/users/afairman/rnaseq/scripts/hisat2.slurm" 

# Loop through all paired-end FASTQ files in the input directory
for read1 in "$INPUT_DIR"/*_R1.fastq.gz; do
    #read2 = read1 with "_R1.fastq.gz" replaced by "_R2.fastq.gz"
    read2="${read1/_R1.fastq.gz/_R2.fastq.gz}"
    
    # Check if the corresponding R2 file exists
    if [ -f "$read2" ]; then
        #Extract the base names of the input files
        read1_base=$(basename "$read1")
        read2_base=$(basename "$read2")
        
        # Submit a separate SLURM job for each pair of reads
        sbatch "$JOB_SCRIPT" "$read1_base" "$read2_base"
        #echo "$read1 | $read2"
    else
        echo "Warning: Corresponding R2 file for $read1 not found. Skipping."
    fi
done