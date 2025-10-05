#!/bin/sh

echo "[INFO] Maintainerr (HA Wrapper) - preparing persistent storage..."

# Prepare persistent path
mkdir -p /data/maintainerr

# Replace ephemeral /opt/data with a symlink
if [ -d /opt/data ]; then
    rm -rf /opt/data
fi
ln -sf /data/maintainerr /opt/data

echo "[INFO] Linked /opt/data -> /data/maintainerr (persistent)"

# s6 will continue boot sequence automatically after this script exits
