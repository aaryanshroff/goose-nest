#!/bin/bash

set -e # Exit if any command fails (returns non-zero exit code)

# Check if the required arguments are provided
while getopts ":r:o:" opt; do
    case $opt in
        r)
            requirements_file="$OPTARG"
            ;;
        o)
            output_path="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# Check if both -r and -o are provided
if [ -z "$requirements_file" ] || [ -z "$output_path" ]; then
    echo "Usage: $0 -r <path/to/requirements.txt> -o <output/path/layer.zip>"
    exit 1
fi

project_root=$(pwd | sed 's|\(.*\/goose-nest\).*|\1|')

# Build the Lambda layer using the Lambda Docker image
docker run \
  -v "$project_root":/var/task \
  "public.ecr.aws/sam/build-python3.11" \
  /bin/sh -c "pip install -r $requirements_file -t python/lib/python3.11/site-packages/; exit"
  
# Download the Firefox driver and include it in the layer
cd $project_root
firefox_driver_url="https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux64.tar.gz"
curl -L $firefox_driver_url | tar -xz -C python

# Download Firefox and include it in the layer
firefox_url="https://download.mozilla.org/?product=firefox-latest-ssl&os=linux"
curl -L $firefox_url | tar -xz -C python

# Create a zip file for the Lambda layer
zip -r $output_path python

# Clean up temporary directory
rm -rf python

echo "Lambda layer payload created at: $output_path"