#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path/to/requirements.txt> <output/path/layer.zip>"
    exit 1
fi

# Set input and output paths
requirements_file="$1"
output_path="$2"

# Build the Lambda layer using the Lambda Docker image
docker run -v "$PWD":/var/task "public.ecr.aws/sam/build-python3.11" /bin/sh -c "pip install -r $requirements_file -t python/lib/python3.6/site-packages/; exit"

# Create a zip file for the Lambda layer
zip -r $output_path python

# Clean up temporary directory
rm -r python

echo "Lambda layer package created at: $output_path"