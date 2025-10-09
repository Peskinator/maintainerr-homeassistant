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

echo "[INFO] Starting Maintainerr application..."

# Try to find the best way to start the app without interfering with s6
# First look for the node app directly
if [ -f /opt/app.js ]; then
  echo "[INFO] Starting Node.js app directly..."
  cd /opt && exec node app.js
elif [ -f /opt/index.js ]; then
  echo "[INFO] Starting index.js..."
  cd /opt && exec node index.js
elif [ -f /app/server.js ]; then
  echo "[INFO] Starting server.js..."
  cd /app && exec node server.js
# If we can't find a direct node entry point, look for npm scripts
elif [ -f /opt/package.json ]; then
  echo "[INFO] Starting with npm..."
  cd /opt && exec npm start
elif [ -f /app/package.json ]; then
  echo "[INFO] Starting with npm..."
  cd /app && exec npm start
# As a last resort, try running the maintainerr command directly
elif command -v maintainerr >/dev/null; then
  echo "[INFO] Running maintainerr command..."
  exec maintainerr
fi

# If we got here, we couldn't find a way to start the app
echo "[ERROR] Could not find a way to start Maintainerr"
echo "[INFO] Listing directories to help debug..."
ls -la /
ls -la /opt 2>/dev/null
ls -la /app 2>/dev/null

# Keep the container running for debugging
tail -f /dev/null
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
