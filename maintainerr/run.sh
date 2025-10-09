#!/bin/sh

echo "[INFO] Starting Maintainerr Add-on..."

# Set environment variables from Home Assistant config
export TZ="${TZ:-Europe/Brussels}"
export API_PORT="${API_PORT:-6246}"
export DATA_DIR="/data"  # Set data directory to the persistent /data folder

# Create symbolic link for persistence
echo "[INFO] Setting up data persistence..."
mkdir -p /data
rm -rf /opt/data 2>/dev/null
ln -sf /data /opt/data

echo "[INFO] Starting Maintainerr Node.js application..."

# Based on the GitHub repo, Maintainerr is a Node.js app
# Check if we need to use PM2 or direct node command
if command -v pm2 >/dev/null; then
  echo "[INFO] Starting with PM2..."
  exec pm2-runtime start /opt/app.js --name maintainerr
elif [ -f /opt/app.js ]; then
  echo "[INFO] Starting with Node directly..."
  cd /opt && exec node app.js
elif [ -f /app/server.js ]; then
  echo "[INFO] Starting server.js..."
  cd /app && exec node server.js
else
  echo "[INFO] Falling back to original container startup..."
  # Let the original container handle startup after we've set up persistence
  # S6 would typically be used in a base container
  if [ -f /init ]; then
    exec /init
  fi
fi

echo "[ERROR] Could not start Maintainerr"
exit 1
# Try examining the original ENTRYPOINT and CMD
echo "[INFO] Checking Dockerfile metadata..."
if [ -f /package/admin/s6/init ]; then
  echo "[INFO] Found S6 init script, running original startup sequence"
  # Let the original S6 initialization take over after our persistence setup
  exec /package/admin/s6/init
fi

echo "[ERROR] Could not find a way to start Maintainerr"
echo "[INFO] Please examine the logs to see how the original container starts"

# Keep container running for debugging
echo "[INFO] Keeping container running for debugging..."
tail -f /dev/null
echo "[INFO] Looking for Node.js application..."
find / -name "package.json" -o -name "server.js" -o -name "index.js" 2>/dev/null | grep -v "node_modules"

# Look for executable files
echo "[INFO] Searching for executable files..."
find /app /opt -type f -executable 2>/dev/null

echo "[ERROR] Could not find Maintainerr binary"
exit 1
