#!/bin/bash

VENV_PATH=".venv"

# Check if the virtual environment directory exists
if [ -d "$VENV_PATH" ]; then
    echo "Virtual environment already exists at $VENV_PATH"
else
    # If it doesn't exist, create it
    echo "Creating virtual environment at $VENV_PATH"
    python3 -m venv "$VENV_PATH"
fi

# Activate the virtual environment
source "$VENV_PATH/bin/activate"

echo "Installing dependencies..."
pip3 install -r src/requirements.txt >/dev/null 2>&1

# Check the exit status of pip install
if [ $? -eq 0 ]; then
    echo "Dependencies installed successfully."
else
    echo "Error: Failed to install dependencies."
fi
