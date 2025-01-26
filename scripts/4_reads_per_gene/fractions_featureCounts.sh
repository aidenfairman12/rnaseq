#!/bin/bash


if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <featureCounts summary file>"
  exit 1
fi

SUMMARY_FILE="$1"

# Check if the file exists
if [[ ! -f "$SUMMARY_FILE" ]]; then
  echo "Error: File '$SUMMARY_FILE' not found."
  exit 1
fi

# Extract column headers
headers=$(head -1 "$SUMMARY_FILE")

# Add up all rows for each column (excluding the header)
totals=$(awk 'NR > 1 {for (i=2; i<=NF; i++) sum[i] += $i} END {for (i=2; i<=NF; i++) printf "%s ", sum[i]}' "$SUMMARY_FILE")

# Calculate fractions for "Assigned" and "Unassigned_Ambiguity"
assigned_fraction=$(awk -v totals="$totals" 'NR > 1 && $1 == "Assigned" {
    split(totals, totalArray, " ")
    for (i=2; i<=NF; i++) printf "%f ", $i / totalArray[i-1]
    printf "\n"
}' "$SUMMARY_FILE")

unassigned_fraction=$(awk -v totals="$totals" 'NR > 1 && $1 == "Unassigned_Ambiguity" {
    split(totals, totalArray, " ")
    for (i=2; i<=NF; i++) printf "%f ", $i / totalArray[i-1]
    printf "\n"
}' "$SUMMARY_FILE")

# Output the results
echo "$headers"
cat "$SUMMARY_FILE"
echo -e "\nAssigned_Fraction $assigned_fraction"
echo -e "Unassigned_Ambiguity_Fraction $unassigned_fraction"