#!/bin/bash

#SBATCH --time=13:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=8000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=hisat2_mapping
#SBATCH --error=/data/users/afairman/rnaseq/outputs/histat2.err
#SBATCH --output=/data/users/afairman/rnaseq/outputs/hisat2.out
#SBATCH --mail-type=TIME_LIMIT_50

#!!!!! DO NOT RUN THIS SCRIPT ALONE. RUN IT FROM THE WRAPPER SCRIPT "submit_hisat2.sh" IN THE SAME DIRECTORY
module load apptainer

# Define path variables and mkdir
OUTPUT_DIR="/data/users/afairman/rnaseq/hisat2_out"
INPUT_DIR="/data/courses/rnaseq_course/breastcancer_de/reads"
IMAGE="/data/users/afairman/rnaseq/images/hisat2_v2.1.0-2-deb_cv1.sif"
mkdir -p "$OUTPUT_DIR"


# Debugging: Print the value of $IMAGE
echo "IMAGE is set to: $IMAGE"

# Check if the image already exists and remove it if it does
if [ -f "$IMAGE" ]; then
    echo "Removing existing image: $IMAGE"
    rm "$IMAGE"
else
    echo "Image does not exist: $IMAGE"
fi

# Pull hisat2-build container image
echo "Pulling HISAT2 container image"
apptainer pull --tmpdir /tmp "$IMAGE" docker://biocontainers/hisat2:v2.1.0-2-deb_cv1

# Ensure that the script receives two arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <reads_1.fastq> <reads_2.fastq>"
    exit 1
fi


# Extract the base names of the input files
reads1_base=$(basename "$1" .fastq.gz)
#reads2_base=$(basename "$2" .fastq.gz)
# Construct the output file name

echo "$1"
echo "$2"
echo "$reads1_base"

output_file="${reads1_base/_R1/}.sam"
echo "output file: /mnt/users/afairman/rnaseq/hisat2_out/$output_file"
echo "-------------"
                                                                                                          
apptainer exec --bind /data:/mnt "$IMAGE" hisat2 -x /mnt/users/afairman/rnaseq/hisat-build_out/GRCh37hg19 -1 "/mnt/courses/rnaseq_course/breastcancer_de/reads/$1" -2 "/mnt/courses/rnaseq_course/breastcancer_de/reads/$2" -S "/mnt/users/afairman/rnaseq/hisat2_out/$output_file"  