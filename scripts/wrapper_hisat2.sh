#!/bin/bash

INPUT_DIR="/data/users/afairman/rnaseq/fastp"
JOB_SCRIPT="/data/users/afairman/scripts/hisat2.slurm"
OUT_ERR="/data/users/afairman/rnaseq/outputs/hisat2"

mkdir -p "$OUT_ERR"

for read1 in "$INPUT_DIR"/*_R1_fastp.R1.fq.gz; do
    read2="${read1/_R1_fastp.R1.fq.gz/_R2_fastp.R2.fq.gz}"

    #echo $read1
    #echo $read2 
    #echo $(basename "$read1" "_R1_fastp.R1.fq.gz")
    name=$(basename "$read1" "_R1_fastp.R1.fq.gz")

    # Check if the corresponding R2 file exists
    if [ -f "$read2" ]; then
        #echo "$read1"
        #echo "$read2"
        #echo "fastp_${name}"
        
        # Submit a separate SLURM job for each pair of reads
        sbatch --job-name="GRCh38_${name}" --error="$OUT_ERR/GRCh38_${name}.err" --output="$OUT_ERR/GRCh38_${name}.out" "$JOB_SCRIPT" "$read1" "$read2" "GRCh38_${name}"

    else
        echo "Warning: Corresponding R2 file for $read1 not found. Skipping."
    fi
done