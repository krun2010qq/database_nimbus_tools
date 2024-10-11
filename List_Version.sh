#!/bin/bash

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
    echo "${GREEN}You selected Greenplum version $chosen_version.${NC}"
else
    echo "Invalid selection."
fi

# Set environment variables
export GPHOME="/usr/local/greenplum-db-$chosen_version"
if [[ -f "$GPHOME/greenplum_path.sh" ]]; then
 #   echo "INFO: Sourcing the Environment Variables"
    source $GPHOME/greenplum_path.sh
else
    echo "Error: $GPHOME/greenplum_path.sh not found."
    exit 1
fi


# Determine MASTER_DATA_DIRECTORY and PGPORT
if [[ "$chosen_version" =~ ^6 ]]; then
#    echo "Version 6 is here"
    export MASTER_DATA_DIRECTORY="/data/master6/gpseg-1"
    export PGPORT=5436
elif [[ "$chosen_version" =~ ^7 ]]; then
    echo "Version 7 is here"
    export MASTER_DATA_DIRECTORY="/data/master7/gpseg-1"
    export PGPORT=5437
fi


# Output with colors
echo -e "${GREEN}Environment set for Greenplum version ${YELLOW}$chosen_version${NC}"
echo -e "${GREEN}GPHOME${NC}: $GPHOME"
echo -e "${GREEN}MASTER_DATA_DIRECTORY${NC}:  $MASTER_DATA_DIRECTORY"
echo -e "${GREEN}PGPORT${NC}: $PGPORT"

