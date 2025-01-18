#!/bin/bash

#SBATCH --time=03:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=8000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=hisat2_indexing_GRCh38
#SBATCH --error=/data/users/afairman/rnaseq/outputs/hisat2build/GRCh38.err
#SBATCH --output=/data/users/afairman/rnaseq/outputs/hisat2build/GRCh38.out
#SBATCH --mail-type=fail

module load apptainer

# Define path variables and mkdir
#OUTPUT_DIR="/data/users/afairman/rnaseq/hisat-build_out"
#INPUT_DIR="/data/users/afairman/rnaseq/fasta"
IMAGE="/data/users/afairman/rnaseq/images/hisat2_v2.1.0-2-deb_cv1.sif"
#TMP_DIR="/scratch/afairman/apptainer-tmp"
#mkdir -p "$OUTPUT_DIR"
#mkdir -p "$TMP_DIR"

if [ -f "$IMAGE" ]; then
    echo "error with image"
fi

#execute indexing with hisat-build
echo "Starting hisat2-build"
# Execute indexing with hisat2-build
apptainer exec --bind /data:/data "$IMAGE" hisat2-build "/data/users/afairman/rnaseq/fasta&gtf/Homo_sapiens.GRCh38.dna.primary_assembly.fa" "/data/users/afairman/rnaseq/hisat-build_out/GRCh38"
echo "Finished hisat2-buid"