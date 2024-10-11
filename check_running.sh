#!/bin/bash

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display available versions with running status
display_versions() {
    echo "Available Greenplum versions:"
    local index=1
    for version in $(ls /usr/local/ | grep -oP 'greenplum-db-\K[0-9.]+' | sort -Vr); do
        if ps aux | grep -v grep | grep "greenplum-db-$version" > /dev/null; then
            echo -e "[${index}] ${YELLOW}$version ${GREEN}Running${NC}"
        else
            echo -e "[${index}] ${YELLOW}$version ${RED}Installed, but not running${NC}"
        fi
        index=$((index+1))
    done
}

# Display available versions
display_versions

# Prompt user to choose a version by number
read -p "Enter the number corresponding to the version you want to use: " chosen_number

# Verify the selected version by number
index=1
for version in $(ls /usr/local/ | grep -oP 'greenplum-db-\K[0-9.]+' | sort -Vr); do
    if [[ $index -eq $chosen_number ]]; then
        chosen_version="$version"
        break
    fi
    index=$((index+1))
done

# Display the selected version
if [[ -n "$chosen_version" ]]; then
    echo "You selected Greenplum version $chosen_version."
else
    echo "Invalid selection."
fi

