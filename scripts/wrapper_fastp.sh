#!/bin/bash

INPUT_DIR="/data/courses/rnaseq_course/breastcancer_de/reads"
JOB_SCRIPT="/data/users/afairman/scripts/fastp.slurm"
OUT_ERR="/data/users/afairman/rnaseq/outputs/out&err"

mkdir -p "$OUT_ERR"

for read1 in "$INPUT_DIR"/*_R1.fastq.gz; do
    #read2 = read1 with "_R1.fastq.gz" replaced by "_R2.fastq.gz"
    read2="${read1/_R1.fastq.gz/_R2.fastq.gz}"
    
    # Check if the corresponding R2 file exists
    if [ -f "$read2" ]; then
        
        # Submit a separate SLURM job for each pair of reads
        #echo $read1 $read2
        sbatch "$JOB_SCRIPT" "$read1" "$read2"
        #echo "$read1 | $read2"
    else
        echo "Warning: Corresponding R2 file for $read1 not found. Skipping."
    fi
done