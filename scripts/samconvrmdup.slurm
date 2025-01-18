#!/bin/bash

#SBATCH --time=10:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=25000	
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4

module load apptainer

#variable definitions
IMAGE="/data/users/afairman/rnaseq/images/samtools"
INPUT_DIR="/data/users/afairman/rnaseq/GRCh38/mapped"
OUTPUT_DIR="/data/users/afairman/rnaseq/GRCh38/bam"

mkdir -p "$OUTPUT_DIR"



#Convert .sam to .bam, Sort .bam, Generate indexes for .sorted.bam. Chained with && so the next command doesnt start until the prior is finished
apptainer exec --bind /data/users/afairman:/data/users/afairman "$IMAGE" samtools view -S -b "$1" > "$OUTPUT_DIR/$2.bam" && \
apptainer exec --bind /data/users/afairman:/data/users/afairman "$IMAGE" samtools sort -@ 4 "$OUTPUT_DIR/$2.bam" -o "$OUTPUT_DIR/$2.sorted.bam" && \
apptainer exec --bind /data/users/afairman:/data/users/afairman "$IMAGE" samtools rmdup  "$OUTPUT_DIR/$2.sorted.bam" "$OUTPUT_DIR/$2.deduped.bam" && \
apptainer exec --bind /data/users/afairman:/data/users/afairman "$IMAGE" samtools index -@ 4 "$OUTPUT_DIR/$2.deduped.bam"



