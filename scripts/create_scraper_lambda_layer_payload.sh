#!/bin/bash
#===============================================================================
# This script builds two Lambda layers (due to layer size being capped at 250MB)
# 1. Python dependencies (requests, selenium, etc.)
# 2. Chrome and chromedriver
#===============================================================================

set -e # Exit if any command fails (returns non-zero exit code)

# Check if the required arguments are provided
while getopts ":r:p:c:" opt; do
    case $opt in
        r)
            requirements_file="$OPTARG"
            ;;
        p)
            python_layer_output="$OPTARG"
            ;;
        c)
            chrome_layer_output="$OPTARG"
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

# Check if all required arguments are provided
if [ -z "$requirements_file" ] || [ -z "$python_layer_output" ] || [ -z "$chrome_layer_output" ]; then
    echo "Usage: $0 -r <path/to/requirements.txt> -p <output/dir/python_layer> -c <output/dir/chrome_layer>"
    exit 1
fi

project_root=$(pwd | sed 's|\(.*\/goose-nest\).*|\1|')

cd $project_root

#===============================================================================
# PYTHON LAYER
#===============================================================================

# Build the Python Lambda layer using the Lambda Docker image
docker run \
  -v "$project_root":/var/task \
  "public.ecr.aws/sam/build-python3.11" \
  /bin/sh -c "pip install -r $requirements_file -t python/lib/python3.11/site-packages/; exit"

zip -r $python_layer_output python

# Clean up temporary directory
rm -rf python

#===============================================================================
# CHROME LAYER
#===============================================================================

CHROMEDRIVER_VERSION="2.32"
HEADLESS_CHROMIUM_VERSION="1.0.0-29"
CHROMELAYER_DIR="chromelayer"

rm -rf chromelayer
mkdir -p chromelayer/bin

# Download and unzip chromedriver
curl -L https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip -o $CHROMELAYER_DIR/chromedriver.zip
tar -xf $CHROMELAYER_DIR/chromedriver.zip -C $CHROMELAYER_DIR/bin/
rm $CHROMELAYER_DIR/chromedriver.zip

# Download and unzip headless chromium
curl -L https://github.com/adieuadieu/serverless-chrome/releases/download/v$HEADLESS_CHROMIUM_VERSION/stable-headless-chromium-amazonlinux-2017-03.zip -o $CHROMELAYER_DIR/headless-chromium.zip
tar -xf $CHROMELAYER_DIR/headless-chromium.zip -C $CHROMELAYER_DIR/bin/
rm $CHROMELAYER_DIR/headless-chromium.zip

# Download shared linux libs
curl -SL https://github.com/21Buttons/pychromeless/blob/master/lib/libORBit-2.so.0?raw=true -o $CHROMELAYER_DIR/lib/libORBit-2.so.0
curl -SL https://github.com/21Buttons/pychromeless/blob/master/lib/libgconf-2.so.4?raw=true -o $CHROMELAYER_DIR/lib/libgconf-2.so.4

# Create a zip file for the Chrome Lambda layer
zip -r $chrome_layer_output $CHROMELAYER_DIR

# Clean up temporary directory
rm -rf chromelayer

echo "Lambda layers created at: $python_layer_output and $chrome_layer_output"