#!/bin/bash

input_file="/data/users/afairman/rnaseq/featureCounts/GRCh38/GRCh38.txt"
output_file="/data/users/afairman/rnaseq/featureCounts/GRCh38/cleanGRCh38.txt"

# Remove the first line and specific columns
# Example: Remove columns 2, 3, and 4
tail -n +2 "$input_file" | cut --complement -f2-6 > "$output_file"

echo "Done."


echo "Done."