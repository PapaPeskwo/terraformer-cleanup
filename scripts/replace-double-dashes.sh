#!/usr/bin/env bash
# This script replaces all occurrences of double dashes (--) with single underscore (_) in all files in the current directory

TARGET_PATH=$1
if [ -z "$TARGET_PATH" ]; then
  TARGET_PATH="."
fi

find "$TARGET_PATH" -type f -exec sed -i '' 's/--/_/g' {} +

echo "Replaced all occurrences of '--' with '_' in files under $TARGET_PATH"
