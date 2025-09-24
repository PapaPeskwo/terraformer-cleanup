#!/usr/bin/env bash
# Remove all instances of a given attribute from all Terraform JSON files in a directory (except provider.tf.json)

if [ $# -lt 2 ]; then
    echo "Usage: $0 <TARGET_PATH> <ATTRIBUTE_NAME>"
    if [ -z "$1" ]; then
        echo "Error: TARGET_PATH parameter is missing."
    fi
    if [ -z "$2" ]; then
        echo "Error: ATTRIBUTE_NAME parameter is missing."
    fi
    exit 1
fi

TARGET_PATH="$1"
ATTRIBUTE_NAME="$2"

# Check if directory exists
if [ ! -d "$TARGET_PATH" ]; then
    echo "Error: Directory '$TARGET_PATH' does not exist."
    exit 2
fi

shopt -s nullglob
FILES=("$TARGET_PATH"/*.tf.json)
shopt -u nullglob

if [ ${#FILES[@]} -eq 0 ]; then
    echo "No .tf.json files found in '$TARGET_PATH'."
    exit 0
fi

for TF_FILE in "${FILES[@]}"; do
    BASENAME=$(basename "$TF_FILE")
    if [ "$BASENAME" = "provider.tf.json" ]; then
        continue
    fi

    if [ ! -w "$TF_FILE" ]; then
        echo "Warning: File '$TF_FILE' is not writable. Skipping."
        continue
    fi

    if ! jq 'walk(if type == "object" then del(.["'"$ATTRIBUTE_NAME"'"]) else . end)' "$TF_FILE" > cleaned.tmp; then
        echo "Error: jq command failed on '$TF_FILE'."
        rm -f cleaned.tmp
        continue
    fi

    if ! mv cleaned.tmp "$TF_FILE"; then
        echo "Error: Failed to overwrite '$TF_FILE'."
        rm -f cleaned.tmp
        continue
    fi

    echo "Successfully removed all instances of '$ATTRIBUTE_NAME' from '$TF_FILE'."
done