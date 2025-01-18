#!/bin/bash

INPUT_DIR="/data/users/afairman/rnaseq/fastp"
JOB_SCRIPT="/data/users/afairman/scripts/fastqc.slurm"
OUT_ERR="/data/users/afairman/rnaseq/outputs"

mkdir -p "$OUT_ERR"

for fastq in "$INPUT_DIR"/*.fq.gz; do
    name=$(basename "$fastq" .fq.gz)
    echo "$fastq"
    echo "$name"
    sbatch --job-name="$name" --error="$OUT_ERR/$name.err" --output="$OUT_ERR/$name.out" "$JOB_SCRIPT" "$fastq" 
done