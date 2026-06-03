#!/bin/bash

# Function to print debug information
debug_print() {
    echo "[DEBUG] $1"
}

set_max_open_files() {
    debug_print "Setting max open files limit"

    # Update system-wide file descriptor limit
    echo "fs.file-max = 65535" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p

    # Update user-level limits
    echo "* soft nofile 65535" | sudo tee -a /etc/security/limits.conf
    echo "* hard nofile 65535" | sudo tee -a /etc/security/limits.conf

    # Ensure PAM applies the limits
    echo "session required pam_limits.so" | sudo tee -a /etc/pam.d/common-session
    echo "session required pam_limits.so" | sudo tee -a /etc/pam.d/common-session-noninteractive

    debug_print "Max open files limit set to 65535"
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

# Update /etc/hosts file (Local only)
update_hosts_file() {
    local old_hostname=$1
    local new_hostname=$2
    debug_print "Updating /etc/hosts file"
    sudo sed -i "s/$old_hostname/$new_hostname/g" /etc/hosts
    debug_print "/etc/hosts file updated"
}

# Get current hostname
current_hostname=$(hostname)
debug_print "Current hostname: $current_hostname"

# Prompt for new hostname
read -p "Enter the new Master/Coordinator hostname (leave blank to keep current): " new_hostname
if [ -n "$new_hostname" ]; then
    debug_print "Updating hostname from $current_hostname to $new_hostname"
    sudo hostnamectl set-hostname $new_hostname
    update_hosts_file $current_hostname $new_hostname
    current_hostname=$new_hostname
else
    debug_print "Keeping current hostname: $current_hostname"
fi

# 获取 Segment 主机列表
echo "-----------------------------------------------------------------"
read -p "Please enter the Segment hostnames (separated by spaces, e.g., sdw1 sdw2 sdw3): " segment_hosts
echo "-----------------------------------------------------------------"

# Disable IPv6
disable_ipv6
# Set Max Open file
set_max_open_files

# 多节点批量打通 SSH 互信
debug_print "Updating the password-free SSH authentication for all nodes"
echo "$current_hostname" > temp_all_hosts
if [ -n "$segment_hosts" ]; then
    for host in $segment_hosts; do
        echo "$host" >> temp_all_hosts
    done
fi
gpssh-exkeys -f temp_all_hosts
rm -f temp_all_hosts
debug_print "SSH password-free authentication completed"


# ==================== 进程与锁文件清理 ====================
echo "-----------------------------------------------------------------"
debug_print "Cleaning up postgres processes and lock files on LOCAL Master..."
pkill -9 -u "$USER" postgres || true
rm -f /tmp/.s.PGSQL.* || true

if [ -n "$segment_hosts" ]; then
    debug_print "Cleaning up postgres processes and lock files on SEGMENT nodes via SSH..."
    for host in $segment_hosts; do
        debug_print "Cleaning $host..."
        ssh -o StrictHostKeyChecking=no "$host" "pkill -9 -u \$USER postgres 2>/dev/null; rm -f /tmp/.s.PGSQL.*" 2>&1 | sed "s/^/[$host] /"
    done
fi
debug_print "Stale postgres processes and lock files cleanup completed"
echo "-----------------------------------------------------------------"


# Update gpinitsystem_config_gpdb6 file
debug_print "Updating gpinitsystem_config_gpdb6 file"
sed -i "s/MASTER_HOSTNAME=.*/MASTER_HOSTNAME=$current_hostname/" gpinitsystem_config_gpdb6
debug_print "gpinitsystem_config_gpdb6 updated"

# Ask user if we need to delete the local data directory
read -p "Do you want to clean up the LOCAL data directory? (yes/no): " confirm

if [[ "$confirm" == "yes" ]]; then
    debug_print "Cleaning up the local data directory"
    find /data/ -mindepth 2 -delete
    debug_print "Completed the cleaning up of the local data directory"
else
    debug_print "Skipping the cleanup of the local data directory"
fi


# Segment 节点远程 SSH 清理与提示
if [ -n "$segment_hosts" ]; then
    echo -e "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "WARNING: This tool will use 'ssh' command to clean up the /data/"
    echo "directory on the following segment hosts: $segment_hosts"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    read -p "Do you want to proceed with cleaning up Segment hosts? (yes/no): " seg_confirm

    if [[ "$seg_confirm" == "yes" ]]; then
        debug_print "Cleaning up segment data directories via SSH..."
        for host in $segment_hosts; do
            debug_print "Connecting to $host to clean up /data/..."
            ssh -o StrictHostKeyChecking=no "$host" "find /data/ -mindepth 2 -delete" 2>/dev/null
        done
        debug_print "Completed the cleaning up of all segment data directories"
    else
        debug_print "Skipping the cleanup of segment data directories"
    fi
fi


# ==================== 优化：在主脚本中进行 /usr/local 目录存在性判断 ====================
if [ -n "$segment_hosts" ]; then
    echo "-----------------------------------------------------------------"
    debug_print "Checking GPDB directory status on remote segments..."
    
    # 自动识别当前生效的 GPHOME 路径
    if [ -z "$GPHOME" ]; then
        DETECTED_GPHOME=$(GP_BIN=$(which gpinitsystem 2>/dev/null); dirname "$(dirname "$GP_BIN")")
    else
        DETECTED_GPHOME=$GPHOME
    fi

    if [ -d "$DETECTED_GPHOME" ]; then
        debug_print "Target detection path: $DETECTED_GPHOME"
        
        # 筛选出真正缺少该目录的 Segment 节点
        hosts_to_sync=""
        for host in $segment_hosts; do
            # 核心改动：使用 ssh 到远端的 /usr/local 去判断该版本目录是否存在
            if ssh -o StrictHostKeyChecking=no "$host" "[ -d '$DETECTED_GPHOME' ]" 2>/dev/null; then
                debug_print "--> [$host]: Already has the directory. [SKIP]"
            else
                debug_print "--> [$host]: MISSING the directory! [NEED SYNC]"
                hosts_to_sync="$hosts_to_sync $host"
            fi
        done

        # 根据筛选结果决定是否调用你的原生脚本
        if [ -n "$hosts_to_sync" ]; then
            # 仅将需要同步的节点写入 $HOME/hostfile，完美配合你的原始脚本
            printf "%s\n" $hosts_to_sync > "$HOME/hostfile"
            
            if [ -f "./sync_usr_local.sh" ]; then
                chmod +x ./sync_usr_local.sh
                debug_print "Calling your original sync_usr_local.sh for: $hosts_to_sync"
                ./sync_usr_local.sh "$DETECTED_GPHOME"
            else
                echo "[WARN] sync_usr_local.sh not found in the current directory!"
            fi
        else
            # 如果所有机器都有了，直接秒过，不执行你的脚本，也就不会触发 tarball
            debug_print "All segment hosts already have the directory. Skipping sync_usr_local.sh completely!"
        fi
    else
        echo "[WARN] Could not detect a valid GPHOME path. Skipping software synchronization."
    fi
    echo "-----------------------------------------------------------------"
fi
# =========================================================================================


# Update gpinitsystem_config_gpdb7 file
debug_print "Updating gpinitsystem_config_gpdb7 file"
sed -i "s/COORDINATOR_HOSTNAME=.*/COORDINATOR_HOSTNAME=$current_hostname/" gpinitsystem_config_gpdb7
debug_print "gpinitsystem_config_gpdb7 updated"

# 动态更新 hostfile_gpinitsystem (供 gpinitsystem 初始化使用，必须包含所有节点)
debug_print "Updating hostfile_gpinitsystem file"
if [ -n "$segment_hosts" ]; then
    printf "%s\n" $segment_hosts > hostfile_gpinitsystem
else
    echo "$current_hostname" > hostfile_gpinitsystem
fi
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
