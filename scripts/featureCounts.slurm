#!/bin/bash

#SBATCH --time=03:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=3000
#SBATCH --cpus-per-task=1
#SBATCH --job-name=featureCountsGRCh38
#SBATCH --error=/data/users/afairman/rnaseq/outputs/featureCounts/GRCh38.err
#SBATCH --output=/data/users/afairman/rnaseq/outputs/featureCounts/GRCh38.out

module load apptainer

INPUT_DIR="/data/users/afairman/rnaseq/GRCh38/bam"
IMAGE="/containers/apptainer/subread_2.0.6.sif"
OUTPUT_DIR="/data/users/afairman/rnaseq/featureCounts/GRCh38"
ANNOT_FILE="/data/users/afairman/rnaseq/fasta&gtf/Homo_sapiens.GRCh38.113.gtf.gz"

mkdir -p "$OUTPUT_DIR"

#array of bam files
files=("$INPUT_DIR"/*.deduped.bam)

input_files="${files[@]}"

#echo $input_files

if [ ! -f "$IMAGE" ]; then
    echo "error retrieving image file"
fi

apptainer exec --bind /data/users/afairman/rnaseq:/data/users/afairman/rnaseq "$IMAGE" featureCounts -p -t exon -g gene_id -a "$ANNOT_FILE" -o "$OUTPUT_DIR.txt" $input_files