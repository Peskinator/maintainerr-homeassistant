#!/bin/sh

# Simple shell script that doesn't rely on bashio
echo "[INFO] Starting Maintainerr Add-on..."

# Set environment variables from config
export TZ="${TZ:-Europe/Brussels}"
export API_PORT="${API_PORT:-6246}"
export DATA_DIR="/data"
export CONFIG_PATH="/data"

# Create symbolic links for persistence
echo "[INFO] Setting up data persistence..."
mkdir -p /data
rm -rf /opt/data 2>/dev/null
ln -sf /data /opt/data

# Debug: Show container directory structure
echo "[INFO] Debugging container structure..."
ls -la /
ls -la /opt/ 2>/dev/null
ls -la /app/ 2>/dev/null

# Debug: Check what processes are running in the container
echo "[INFO] Looking for running processes..."
ps aux

# Try to find the binary using various patterns
echo "[INFO] Searching for Maintainerr binary..."

# Try known common paths with case variations
for binary in \
  /app/maintainerr \
  /app/Maintainerr \
  /opt/maintainerr/maintainerr \
  /opt/maintainerr/Maintainerr \
  /maintainerr \
  /Maintainerr \
  /usr/bin/maintainerr \
  /usr/local/bin/maintainerr
do
  if [ -f "$binary" ]; then
    echo "[INFO] Found Maintainerr at $binary"
    exec "$binary"
  fi
done

# Look for likely candidates in PATH
echo "[INFO] Checking PATH for maintainerr..."
which maintainerr 2>/dev/null
which Maintainerr 2>/dev/null

# Look for JS files if it's a Node app
echo "[INFO] Looking for Node.js application..."
find / -name "package.json" -o -name "server.js" -o -name "index.js" 2>/dev/null | grep -v "node_modules"

# Look for executable files
echo "[INFO] Searching for executable files..."
find /app /opt -type f -executable 2>/dev/null

echo "[ERROR] Could not find Maintainerr binary"
exit 1
