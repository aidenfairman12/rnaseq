#!/bin/bash

#SBATCH --time=1:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=2500
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --array=0-11
#SBATCH --job-name=multi_mapped_array
#SBATCH --error=/data/users/afairman/rnaseq/outputs/check_multiMap/job_%A_%a.err
#SBATCH --output=/data/users/afairman/rnaseq/outputs/check_multiMap/job_%A_%a.ou

module load apptainer

###This script can be used to investigate statistics about each bam file. Not necessary for analysis.


#variable definitions
HOME_DIR="/data/users/afairman/rnaseq"
IMAGE="/containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif"
INPUT_DIR="/data/users/afairman/rnaseq/GRCh38/bam"
OUTPUT_DIR="/data/users/afairman/rnaseq/outputs/check_multiMap"


files=("$INPUT_DIR"/*.deduped.bam)

input_file="${files[$SLURM_ARRAY_TASK_ID]}"


if [ ! -f "$IMAGE" ]; then
    echo "error retrieving image file"
fi

output_file="$OUTPUT_DIR/$(basename ${input_file%.bam}).flagstat.txt"
apptainer exec --bind "$HOME_DIR" "$IMAGE" samtools flagstat $input_file > "$output_file"