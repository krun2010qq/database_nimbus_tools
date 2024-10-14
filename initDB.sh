#!/bin/bash

# Function to print debug information
debug_print() {
    echo "[DEBUG] $1"
}

# Disable IPv6
disable_ipv6() {
    debug_print "Disabling IPv6"
    echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
    echo "net.ipv6.conf.lo.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    debug_print "IPv6 disabled"
}

# Update /etc/hosts file
update_hosts_file() {
    local old_hostname=$1
    local new_hostname=$2
    debug_print "Updating /etc/hosts file"
    sudo sed -i "s/$old_hostname/$new_hostname/g" /etc/hosts
    debug_print "/etc/hosts file updated"
    gpssh-exkeys -h $new_hostname
    debug_print "updating the password-free SSH authentication"
}

# Get current hostname
current_hostname=$(hostname)
debug_print "Current hostname: $current_hostname"

# Prompt for new hostname
read -p "Enter the new hostname (leave blank to keep current): " new_hostname
if [ -n "$new_hostname" ]; then
    debug_print "Updating hostname from $current_hostname to $new_hostname"
    sudo hostnamectl set-hostname $new_hostname
    update_hosts_file $current_hostname $new_hostname
    current_hostname=$new_hostname
else
    debug_print "Keeping current hostname: $current_hostname"
fi

# Disable IPv6
disable_ipv6

# Update gpinitsystem_config_gpdb6 file
debug_print "Updating gpinitsystem_config_gpdb6 file"
sed -i "s/MASTER_HOSTNAME=.*/MASTER_HOSTNAME=$current_hostname/" gpinitsystem_config_gpdb6
debug_print "gpinitsystem_config_gpdb6 updated"

# Ask user if we need to delete the data directory
read -p "Do you want to clean up the data directory? (yes/no): " confirm

if [[ "$confirm" == "yes" ]]; then
    debug_print "Cleaning up the data directory"
    find /data/ -mindepth 2 -delete
    debug_print "Completed the cleaning up of the data directory"
else
    debug_print "Skipping the cleanup of the data directory"
fi


# Update gpinitsystem_config_gpdb7 file
debug_print "Updating gpinitsystem_config_gpdb7 file"
sed -i "s/COORDINATOR_HOSTNAME=.*/COORDINATOR_HOSTNAME=$current_hostname/" gpinitsystem_config_gpdb7
debug_print "gpinitsystem_config_gpdb7 updated"

# Update hostfile_gpinitsystem file
debug_print "Updating hostfile_gpinitsystem file"
echo "$current_hostname" > hostfile_gpinitsystem
debug_print "hostfile_gpinitsystem updated"

# Ask user for GPDB version
read -p "Please select GPDB version (6 or 7): " gpdb_version
debug_print "User selected GPDB version: $gpdb_version"

# Execute gpinitsystem command based on user selection
if [ "$gpdb_version" = "6" ]; then
    debug_print "Initializing GPDB 6"
    gpinitsystem -c gpinitsystem_config_gpdb6 -h hostfile_gpinitsystem
elif [ "$gpdb_version" = "7" ]; then
    debug_print "Initializing GPDB 7"
    gpinitsystem -c gpinitsystem_config_gpdb7 -h hostfile_gpinitsystem
else
    echo "Invalid choice. Please enter 6 or 7."
    debug_print "Invalid GPDB version selected: $gpdb_version"
    exit 1
fi

debug_print "Script execution completed"
