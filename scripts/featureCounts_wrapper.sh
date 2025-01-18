#!/bin/bash

INPUT_DIR="/data/users/afairman/rnaseq/bamFiles"
JOB_SCRIPT="/data/users/afairman/scripts/featureCounts.slurm"
OUT_ERR="/data/users/afairman/rnaseq/outputs/fc_out"

mkdir -p "$OUT_ERR"

for bam in "$INPUT_DIR"/*.sorted.bam; do
        name=$(basename "$bam" .sorted.bam)
        echo "$bam"
        echo "$name"
        sbatch --job-name="${name}_fc" --error="${OUT_ERR}/${name}.err" --output="${OUT_ERR}/${name}.out" "$JOB_SCRIPT" "$bam" "$name"
     
done