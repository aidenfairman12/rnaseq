#!/bin/bash

#SBATCH --time=02:00:00
#SBATCH --partition=pcoursea
#SBATCH --mem=2000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2


module load apptainer


HOME_DIR=/data
IMAGE=/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif
OUTPUT_DIR=/data/users/afairman/rnaseq/fastp
base1=$(basename "$1" .fastq.gz)
base2=$(basename "$2" .fastq.gz)

mkdir -p "$OUTPUT_DIR"

if [ -f !$IMAGE ]; then
    echo "error with image path"
fi

apptainer exec --bind "$HOME_DIR":"$HOME_DIR" "$IMAGE" fastp -i "$1" -I "$2" -o "${base1}_fastp.R1.fq.gz" -O "${base2}_fastp.R2.fq.gz"
