#!/usr/bin/env bash
# This script removes all instances of a specified attribute with a specified value from a Terraform JSON file using jq.

if [ $# -lt 3 ]; then
    echo "Usage: $0 <TF_FILE> <ATTRIBUTE_NAME> <ATTRIBUTE_VALUE>"
    if [ -z "$1" ]; then
        echo "Error: TF_FILE parameter is missing."
    fi
    if [ -z "$2" ]; then
        echo "Error: ATTRIBUTE_NAME parameter is missing."
    fi
    if [ -z "$3" ]; then
        echo "Error: ATTRIBUTE_VALUE parameter is missing."
    fi
    exit 1
fi

TF_FILE="$1"
ATTRIBUTE_NAME="$2"
ATTRIBUTE_VALUE="$3"

# Check if file exists and is writable
if [ ! -f "$TF_FILE" ] || [ ! -w "$TF_FILE" ]; then
    echo "Error: File '$TF_FILE' does not exist or is not writable."
    exit 2
fi

# Run jq and check for errors
if ! jq 'del(.resource[]?.*?.'"$ATTRIBUTE_NAME"' | select (. == "'"$ATTRIBUTE_VALUE"'"))' "$TF_FILE" > cleaned.tmp; then
    echo "Error: jq command failed."
    rm -f cleaned.tmp
    exit 3
fi

# Move the cleaned file back, check for errors
if ! mv cleaned.tmp "$TF_FILE"; then
    echo "Error: Failed to overwrite '$TF_FILE'."
    rm -f cleaned.tmp
    exit 4
fi

echo "Successfully removed all instances of '$ATTRIBUTE_NAME' with value '$ATTRIBUTE_VALUE' from '$TF_FILE'."