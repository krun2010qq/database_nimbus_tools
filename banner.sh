#!/bin/bash

# Define colors and formatting
BOLD=$(tput bold)
RESET=$(tput sgr0)
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
RED="\033[1;31m"
NC="\033[0m"  # No color

# Get the hostname
HOSTNAME=$(hostname)

# Clear the terminal for a clean display
clear

# Create a clean ASCII banner using echo
echo -e "${CYAN}${BOLD}"
echo "############################################################"
echo "#                                                          #"
echo "#               WELCOME TO THE SUPPORT LAB                 #"
echo "#                                                          #"
echo "############################################################"
echo -e "${RESET}"

# Display hostname
echo -e "${YELLOW}${BOLD}Hostname: ${HOSTNAME}${RESET}"
echo -e "${CYAN}==================================================${RESET}"

# Display professional guidelines
echo -e "${GREEN}${BOLD}All useful scripts are located in:${RESET} ~/database_nimbus_tools"
echo
echo -e "${BLUE}${BOLD}1. To download software with *root* account:${RESET}"
echo -e "   Use ${CYAN}download.py${RESET} (alias: ${MAGENTA}gpdownload${RESET})."
echo
echo -e "${BLUE}${BOLD}2. To check the current Greenplum version with *gpadmin* account:${RESET}"
echo -e "   Run ${CYAN}List_Version.sh${RESET} (alias: ${MAGENTA}gpdb${RESET})."
echo
echo -e "${BLUE}${BOLD}3. To reinitialize Greenplum installation with *root* account:${RESET}"
echo -e "   Execute ${CYAN}initDB.sh${RESET} (alias: ${MAGENTA}reinitdb${RESET})."
echo
echo -e "${RED}${BOLD}Note:${RESET} Always back up your data before reinitializing."
echo -e "${CYAN}==================================================${RESET}"

# Fetch and display Greenplum Database versions using List_Version.sh script
echo -e "${MAGENTA}${BOLD}Available Greenplum Versions:${RESET}"

index=1  # Initialize index for version numbering
for version in $(ls /usr/local/ | grep -oP 'greenplum-db-\K[0-9.]+' | sort -Vr); do
    # Check if the version is running by searching for its process
    if ps aux | grep -v grep | grep "greenplum-db-$version" > /dev/null; then
        echo -e "   [${index}] ${YELLOW}$version ${GREEN}(Running)${NC}"
    else
        echo -e "   [${index}] ${YELLOW}$version ${RED}(Installed, but not running)${NC}"
    fi
    index=$((index+1))  # Increment index for next version
done

# Add a decorative footer line
echo -e "${CYAN}==================================================${RESET}"

