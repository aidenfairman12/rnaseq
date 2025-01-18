#!/bin/bash

# Define the input directory
INPUT_DIR="/data/users/afairman/rnaseq/GRCh38/mapped"
JOB_SCRIPT="/data/users/afairman/scripts/samconvrmdup.slurm" 
OUT_ERR="/data/users/afairman/rnaseq/outputs/samconvrmdup/GRCh38"

mkdir -p "$OUT_ERR"

# Loop through all paired-end FASTQ files in the input directory
for sam in "$INPUT_DIR"/*.sam; do
        name=$(basename "$sam" .sam)
        
        sbatch --job-name="${name}_conv" --error="$OUT_ERR/$name.err" --output="$OUT_ERR/$name.out" "$JOB_SCRIPT" "$sam" "$name"
done