#!/bin/bash

#SBATCH --time=02:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=1000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2

###USE WRAPPER SCRIPT TO RUN THIS SCRIPT
module load apptainer

# Define input and output directories
INPUT_DIR="/data/courses/rnaseq_course/breastcancer_de/reads/"
OUTPUT_DIR="/data/users/afairman/finalGrouph/qc/cleaned"
IMAGE="/data/users/afairman/rnaseq/images/fastqc-0.12.1.sif"


# Create necessary directories
mkdir -p "$OUTPUT_DIR"


# Check if the FastQC container image already exists
if [ ! -f "$IMAGE" ]; then
    # Pull the FastQC container image using Apptainer
    echo "ERROR accessing fastqc image"
fi

# Convert INPUT_DIR to the mounted path




# Run FastQC using the pulled container image
apptainer exec --bind /data:/data "$IMAGE" fastqc -o "$OUTPUT_DIR" $1

