#!/bin/bash

#SBATCH --time=13:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=8000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8

#!!!!! DO NOT RUN THIS SCRIPT ALONE. RUN IT FROM THE WRAPPER SCRIPT "submit_hisat2.sh" IN THE SAME DIRECTORY
### UPDATE THIS LINE EACH TIME YOU USE THIS WITH THE LAST SET OF FILES USED: eg. /data/users/afairman/rnaseq/fastp/rnaseq/fastp/X_R1_fastp.R1.fq.gz
module load apptainer

# Define path variables and mkdir
OUTPUT_DIR="/data/users/afairman/rnaseq/GRCh38/mapped"
IMAGE="/data/users/afairman/rnaseq/images/hisat2_v2.1.0-2-deb_cv1.sif"
mkdir -p "$OUTPUT_DIR"


# Check if the image already exists and remove it if it does
if [ -f !$IMAGE ]; then
    echo "error with image path"
fi

# Ensure that the script receives 3 arguments
if [ "$#" -ne 3 ]; then
    echo "Did not receive 3 arguments"
    exit 1
fi

apptainer exec --bind /data/users/afairman:/data/users/afairman "$IMAGE" hisat2 -x /data/users/afairman/rnaseq/hisat-build_out/GRCh38 -1 "$1" -2 "$2" -S "${OUTPUT_DIR}/${3}.sam" -p 8