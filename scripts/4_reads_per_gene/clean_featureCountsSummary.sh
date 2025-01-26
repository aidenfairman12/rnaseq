#!/bin/bash

input_file="/data/users/afairman/rnaseq/featureCounts/GRCh38_with_cRP/GRch38_with_cRP.txt"
output_file="/data/users/afairman/rnaseq/featureCounts/GRCh38_with_cRP/GRch38_with_cRP.txt2"
echo "hello"

# Read the first line
first_line=$(head -n 1 "$input_file")
echo "Processing first line..."
echo "$first_line" | awk 'BEGIN {OFS="\t"} {
    for (i=1; i<=NF; i++) {
        if ($i ~ /\.bam$/) {
            $i = gensub(".*/", "", "g", $i)
            $i = gensub(".sorted.bam", "", "g", $i)
            $i = gensub(".deduped.bam", "", "g", $i)
            $i = gensub("fastp_", "", "g", $i )
            $i = gensub("GRCh38_", "", "g", $i)
        }
    }
    print
}' > "$output_file"

echo "Processing remaining lines..."
# Append the rest of the file unchanged
tail -n +2 "$input_file" >> "$output_file"

echo "Done."