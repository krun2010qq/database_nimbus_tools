#!/bin/bash

# sync_usr_local.sh
# Usage: ./sync_usr_local.sh /usr/local/greenplum-db-7.5.5
# Compresses the GPDB directory, transfers it to remote hosts, extracts to the target path with gpadmin:gpadmin ownership.

GPDB_PATH="$1"
HOSTFILE="$HOME/hostfile"
CUR_HOSTNAME=$(hostname)
BASENAME=$(basename "$GPDB_PATH")
TARFILE="/tmp/${BASENAME}.sync.$$.$(date +%s).tar.gz"

# Check if the source GPDB directory exists
if [[ ! -d "$GPDB_PATH" ]]; then
    echo "[ERROR] Directory does not exist: $GPDB_PATH"
    exit 1
fi

# Check if the hostfile exists
if [[ ! -f "$HOSTFILE" ]]; then
    echo "[ERROR] Host file not found: $HOSTFILE"
    exit 2
fi

# Create tarball
echo "[INFO] Creating tarball: $TARFILE ..."
tar -czf "$TARFILE" -C /usr/local "$BASENAME"
if [[ $? -ne 0 ]]; then
    echo "[FAIL] Failed to create tarball"
    exit 3
fi

# Loop through each host
for host in $(cat "$HOSTFILE"); do
    if [[ "$host" == "$CUR_HOSTNAME" ]]; then
        echo "[INFO] Skipping local host: $host"
        continue
    fi

    REMOTE_TAR="/tmp/${BASENAME}.sync.$$.$(date +%s).tar.gz"
    echo "[INFO] Copying tarball to $host:$REMOTE_TAR ..."
    scp "$TARFILE" "$host:$REMOTE_TAR"
    if [[ $? -ne 0 ]]; then
        echo "[FAIL] scp tarball failed for $host"
        continue
    fi

    echo "[INFO] Extracting tarball to $GPDB_PATH on $host, setting ownership to gpadmin:gpadmin ..."
    ssh "$host" "sudo mkdir -p '$GPDB_PATH' && sudo tar -xzf '$REMOTE_TAR' -C /usr/local && sudo chown -R gpadmin:gpadmin '$GPDB_PATH' && rm -f '$REMOTE_TAR'"
    if [[ $? -eq 0 ]]; then
        echo "[SUCCESS] GPDB directory synchronized to $host with ownership gpadmin:gpadmin"
    else
        echo "[FAIL] Remote sudo untar or chown failed for $host"
    fi
done

# Remove local tarball
rm -f "$TARFILE"

echo "========== Sync Complete =========="

