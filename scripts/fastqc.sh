#!/bin/bash

#SBATCH --job-name=fastqc
#SBATCH --output=first.out
#SBATCH --error=first.err
#SBATCH --time=02:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=1000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2

# Load Apptainer module if necessary
module load apptainer

# Define input and output directories
INPUT_DIR="/data/courses/rnaseq_course/breastcancer_de/reads"
OUTPUT_DIR="/data/users/afairman/rnaseq/fastqc_out"
TMP_DIR="/scratch/afairman/apptainer-tmp"

# Create necessary directories
mkdir -p "$OUTPUT_DIR"
mkdir -p "$TMP_DIR"

# Print debug information
echo "INPUT_DIR: $INPUT_DIR"
echo "OUTPUT_DIR: $OUTPUT_DIR"
echo "TMP_DIR: $TMP_DIR"

# Check if the FastQC container image already exists
if [ ! -f "fastqc-0.12.1.sif" ]; then
    # Pull the FastQC container image using Apptainer
    APPTAINER_TMPDIR="$TMP_DIR" apptainer pull --disable-cache --name "fastqc-0.12.1.sif" docker://quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0
fi

# Verify the output directory inside the container
apptainer exec --bind /data/users/afairman/rnaseq/fastqc_out:/data/users/afairman/rnaseq/fastqc_out fastqc-0.12.1.sif ls /data/users/afairman/rnaseq/fastqc_out

# Run FastQC using the pulled container image
apptainer exec --bind /data/courses/rnaseq_course/breastcancer_de/reads:/data/courses/rnaseq_course/breastcancer_de/reads --bind /data/users/afairman/rnaseq/fastqc_out:/data/users/afairman/rnaseq/fastqc_out fastqc-0.12.1.sif fastqc -o "$OUTPUT_DIR" "$INPUT_DIR"/*.fastq.gz