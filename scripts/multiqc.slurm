#!/bin/bash

#SBATCH --time=05:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=6000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=multiqc
#SBATCH --output=/data/users/afairman/rnaseq/outputs/multiqc.out
#SBATCH --error=/data/users/afairman/rnaseq/outputs/multiqc.err

HOME_DIR=/data/users/afairman
INPUT_DIR="/data/users/afairman/finalGrouph/qc/together"
OUTPUT_DIR="/data/users/afairman/finalGrouph/qc/together/multiqc"
IMAGE="/containers/apptainer/multiqc-1.19.sif"

mkdir -p "$OUTPUT_DIR"

if [ ! -f "$IMAGE" ]; then
    echo "ERROR ACCESSING IMAGE"
fi


apptainer exec --bind "$HOME_DIR":"$HOME_DIR" "$IMAGE" bash -c "
echo 'Chosen files:'
ls \"$INPUT_DIR\"/*.zip
multiqc -o \"$OUTPUT_DIR\" \"$INPUT_DIR\"/*.zip
"