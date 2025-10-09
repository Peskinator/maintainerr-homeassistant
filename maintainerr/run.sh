#!/bin/sh

echo "[INFO] Starting Maintainerr Add-on..."

# The original application saves data to /opt/data.
# We will redirect this to the persistent /data folder from Home Assistant.
echo "[INFO] Creating symlink for data persistence..."
rm -rf /opt/data
ln -s /data /opt/data

echo "[INFO] Starting Maintainerr application..."
# Execute the original Maintainerr binary
exec /app/maintainerr
# Ensure persistent config directory exists
mkdir -p /data

# Start the application
exec npm start
