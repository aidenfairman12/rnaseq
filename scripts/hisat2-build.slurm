#!/bin/bash

#SBATCH --time=03:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=8000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=hisat2_indexing
#SBATCH --error=/data/users/afairman/rnaseq/outputs/histat2build.err
#SBATCH --output=/data/users/afairman/rnaseq/outputs/hisat2build.out
#SBATCH --mail-type=fail,done

module load apptainer

# Define path variables and mkdir
OUTPUT_DIR="/data/users/afairman/rnaseq/hisat-build_out"
INPUT_DIR="/data/users/afairman/rnaseq/fasta"
IMAGE="/data/users/afairman/rnaseq/images/hisat2_v2.1.0-2-deb_cv1.sif"
ASS="Homo_sapiens.GRCh37.dna.primary_assembly.fa"
#TMP_DIR="/scratch/afairman/apptainer-tmp"
mkdir -p "$OUTPUT_DIR"
#mkdir -p "$TMP_DIR"

#Check if input and images are correct
if [ ! -f "$INPUT_DIR/$ASS" ]; then
    echo "err: Input file does not exist"
    exit 1
fi

if [ -f "$IMAGE" ]; then
    rm "$IMAGE"
fi

# Pull hisat2-build container image
apptainer pull --tmpdir /tmp "$IMAGE" docker://biocontainers/hisat2:v2.1.0-2-deb_cv1

#execute indexing with hisat-build
echo "Starting hisat2-build"
# Execute indexing with hisat2-build
apptainer exec --bind /data:/mnt "$IMAGE" hisat2-build "/mnt/users/afairman/rnaseq/fasta/$ASS" "/mnt/users/afairman/rnaseq/hisat-build_out/GRCh37hg19"
echo "Finished hisat2-buid"