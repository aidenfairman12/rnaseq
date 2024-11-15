#!/bin/bash

# Define the input directory
INPUT_DIR="/data/users/afairman/rnaseq/samFiles"
JOB_SCRIPT="/data/users/afairman/rnaseq/scripts/samconv.slurm" 

# Loop through all paired-end FASTQ files in the input directory
for sam in "$INPUT_DIR"/*.sam; do
        job_name=$(basename "$sam" .sam)
        sbatch --job-name="$job_name" --error="$job_name.err" --output="$job_name.out" "$JOB_SCRIPT" "$sam" 
done