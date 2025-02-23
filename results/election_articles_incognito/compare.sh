#!/bin/bash

# Path to the directories
DEFAULT_PATH="./self/default"
SELF_PATH="./self"

# Loop through product1 to product10
for i in {1..10}; do
  product="product$i"
  
  echo "Checking files in $product..."
  
  # Check if both directories exist
  if [ ! -d "$DEFAULT_PATH/$product" ]; then
    echo "ERROR: $DEFAULT_PATH/$product does not exist!"
    continue
  fi
  
  if [ ! -d "$SELF_PATH/$product" ]; then
    echo "ERROR: $SELF_PATH/$product does not exist!"
    continue
  fi
  
  # Find all files in the default product directory
  default_files=$(find "$DEFAULT_PATH/$product" -type f | sort)
  
  # Find all files in the self product directory
  self_files=$(find "$SELF_PATH/$product" -type f | sort)
  
  # Check if file lists are the same
  default_file_count=$(echo "$default_files" | wc -l)
  self_file_count=$(echo "$self_files" | wc -l)
  
  if [ "$default_file_count" -ne "$self_file_count" ]; then
    echo "✗ File count mismatch: $DEFAULT_PATH/$product has $default_file_count files, $SELF_PATH/$product has $self_file_count files"
  fi
  
  # Compare each file individually
  echo "Comparing individual files:"
  
  # Create arrays of filenames only (without the path prefix)
  mapfile -t default_file_names < <(find "$DEFAULT_PATH/$product" -type f -printf "%P\n" | sort)
  mapfile -t self_file_names < <(find "$SELF_PATH/$product" -type f -printf "%P\n" | sort)
  
  # Check for files in default that don't exist in self
  for file in "${default_file_names[@]}"; do
    if [[ ! " ${self_file_names[*]} " =~ " ${file} " ]]; then
      echo "  ✗ File $file exists in $DEFAULT_PATH/$product but not in $SELF_PATH/$product"
    fi
  done
  
  # Check for files in self that don't exist in default
  for file in "${self_file_names[@]}"; do
    if [[ ! " ${default_file_names[*]} " =~ " ${file} " ]]; then
      echo "  ✗ File $file exists in $SELF_PATH/$product but not in $DEFAULT_PATH/$product"
    fi
  done
  
  # Compare content of files that exist in both
  for file in "${default_file_names[@]}"; do
    if [[ " ${self_file_names[*]} " =~ " ${file} " ]]; then
      # Both files exist, compare content
      if ! cmp -s "$DEFAULT_PATH/$product/$file" "$SELF_PATH/$product/$file"; then
        echo "  ✗ File $file has different content in the two locations"
      else
        echo "  ✓ File $file identical in both locations"
      fi
    fi
  done
  
  echo "-----------------------------------"
done
