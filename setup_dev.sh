#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NC=$(tput sgr0)

VENV_PATH=".venv"

# Check if the virtual environment directory exists
if [ -d "$VENV_PATH" ]; then
    echo "Virtual environment already exists at ${VENV_PATH}"
else
    # If it doesn't exist, create it
    echo "Creating virtual environment at $VENV_PATH"
    python3 -m venv "$VENV_PATH"
    echo "${GREEN}Virtual environment created.${NC}"
fi

# Activate the virtual environment
source "$VENV_PATH/bin/activate"

echo "Installing dependencies..."
pip3 install -r src/requirements.txt >/dev/null 2>&1

# Check the exit status of pip install
if [ $? -eq 0 ]; then
    echo "${GREEN}Dependencies installed successfully.${NC}"
else
    echo -e "${RED}Error: Failed to install dependencies.${NC}"
fi
