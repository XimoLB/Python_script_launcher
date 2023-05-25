#!/usr/bin/env bash

# Python script launcher for Linux by Ximo
# Version: 1.0.0

# Disclaimer:
# This work is licensed under the Creative Commons Attribution 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.
# You are free to modify, distribute, and use this script for your own purposes, including commercial use, as long as proper attribution is given to the original author.

# The author retains the copyright and shall not be held liable for any issues or damages arising from the use of this script.
# This script is provided as-is, without any warranty.
# Use it at your own risk.

# Requirements:
# - Bash shell
# - Python 3

# Description:
# This script searches for Python scripts in the current directory and subdirectories and launches the selected script. It provides an interactive menu for script selection, displays script information, and allows passing command-line arguments to the chosen script.

# Usage:
# 1. Open a terminal on your linux system.
# 2. Navigate to the directory containing the script launcher.
# 3. Run the script by executing the following command: ./python_script_launcher.sh
# 4. Follow the prompts and provide any necessary input when prompted.
# 5. The selected Python script will be launched.


# Ensure that the script will exit if any commands fail and treat unset variables as an error
set -eu
# Enable 'pipefail' to cause a pipeline to fail if any command fails (even if it's not the last command)
set -o pipefail

# Get the current script directory
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Check if the script directory exists
if [[ ! -d "$script_dir" ]]; then
    echo "Unable to determine script directory. Exiting."
    exit 1
fi

# Change to the script directory
cd "$script_dir"

# Function to display the script selection menu
select_script() {
    local options=("Quit" "${python_scripts[@]}")
    PS3="Please enter the number corresponding to the script you want to run: "
    select script_name in "${options[@]}"; do
        if [[ $REPLY -eq 1 ]]; then
            echo "Exiting."
            exit 0
        elif [[ -n $script_name ]]; then
            break
        else
            echo "Invalid option. Please try again."
        fi
    done
}

# Function to display the script information
display_script_info() {
    local script_info_file="${script_name}.txt"
    if [[ -f $script_info_file ]]; then
        echo "Script information:"
        cat "$script_info_file"
        echo
    fi
}

# Get a list of Python scripts in the current directory and subdirectories
shopt -s globstar nullglob
python_scripts=( ./**/*.py )

# Check if there are any Python scripts
if [[ ${#python_scripts[@]} -eq 0 ]]; then
    echo "No Python scripts found in the current directory."
    exit 1
fi

# Check if there is only one Python script
if [[ ${#python_scripts[@]} -eq 1 ]]; then
    script_name="${python_scripts[0]}"
else
    # Present script selection menu
    select_script
fi

# Display script information
display_script_info

# Run the chosen Python script
python3 "$script_name" "$@"
