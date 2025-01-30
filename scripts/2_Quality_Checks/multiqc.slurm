#!/bin/bash

#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=2000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=multiqc
#SBATCH --output=/data/users/afairman/rnaseq/outputs/multiqc.out
#SBATCH --error=/data/users/afairman/rnaseq/outputs/multiqc.err

HOME_DIR=/data/users/afairman
INPUT_DIR="/data/users/afairman/rnaseq/featureCounts/GRCh38_with_cRP"
OUTPUT_DIR="/data/users/afairman/rnaseq/featureCounts/multiqc"
IMAGE="/containers/apptainer/multiqc-1.19.sif"

mkdir -p "$OUTPUT_DIR"

if [ ! -f "$IMAGE" ]; then
    echo "ERROR ACCESSING IMAGE"
fi


apptainer exec --bind "$HOME_DIR":"$HOME_DIR" "$IMAGE" multiqc -o "$OUTPUT_DIR" "$INPUT_DIR"
