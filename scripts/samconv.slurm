#!/bin/bash

#SBATCH --time=10:00:00
#SBATCH --partition=pibu_el8
#SBATCH --mem=25000	
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4

module load apptainer

#variable definitions
IMAGE="/data/users/afairman/rnaseq/images/samtools"
INPUT_DIR="users/afairman/rnaseq/samFiles"
OUTPUT_DIR="users/afairman/rnaseq/bamFiles"

mkdir -p "data/$OUTPUT_DIR"

file_name=$(basename "$1" .sam)

echo ""/mnt/$OUTPUT_DIR/$file_name.bam""

#Convert .sam to .bam, Sort .bam, Generate indexes for .sorted.bam. Chained with && so the next command doesnt start until the prior is finished
#apptainer exec --bind /data:/mnt "$IMAGE" samtools view -S -b "/mnt/users/afairman/rnaseq/samFiles/$file_name.sam" > "/mnt/users/afairman/rnaseq/bamFiles/$file_name.bam" && \
#apptainer exec --bind /data:/mnt "$IMAGE" samtools sort "/mnt/$OUTPUT_DIR/$file_name.bam" -o "/mnt/$OUTPUT_DIR/$file_name.sorted.bam" && \
#apptainer exec --bind /data:/mnt "$IMAGE" samtools index -@ 4 "/mnt/$OUTPUT_DIR/$file_name.sorted.bam"



#echo "Fished with conversion, sorting and indexing of bam files"

apptainer exec --bind /data:/mnt "$IMAGE" bash -c "
if [ -f \"/mnt/$OUTPUT_DIR/$file_name.bam\" ]; then
    echo \"/mnt/$OUTPUT_DIR/$file_name.bam already exists.\"
else
    samtools view -S -b \"/mnt/$INPUT_DIR/$file_name.sam\" > \"/mnt/$OUTPUT_DIR/$file_name.bam\" && \
    echo \"finished with samtools view for $file_name\" && \
    samtools sort \"/mnt/$OUTPUT_DIR/$file_name.bam\" -o \"/mnt/$OUTPUT_DIR/$file_name.sorted.bam\" && \
    echo \"finished with samtools sort for $file_name\" && \
    samtools index -@ 4 \"/mnt/$OUTPUT_DIR/$file_name.sorted.bam\" && \
    echo \"finished with samtools index for $file_name\" && \
    echo \"Finished with conversion, sorting and indexing of bam files\"
fi
"