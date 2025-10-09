#!/bin/sh

echo "[INFO] Starting Maintainerr Add-on..."

# Set environment variables from Home Assistant config
export TZ="${TZ:-Europe/Brussels}"
export API_PORT="${API_PORT:-6246}"
export DATA_DIR="/data"
export CONFIG_PATH="/data"

# Create symbolic link for persistence
echo "[INFO] Setting up data persistence..."
mkdir -p /data
rm -rf /opt/data 2>/dev/null
ln -sf /data /opt/data

echo "[INFO] Starting Maintainerr application..."

# Based on the GitHub repo, this is a Node.js Express app
# Check for PM2 which is commonly used in the Docker image
if command -v pm2 >/dev/null; then
  echo "[INFO] Starting with PM2..."
  exec pm2-runtime start /opt/maintainerr/server.js --name maintainerr
elif [ -f /opt/maintainerr/server.js ]; then
  echo "[INFO] Starting server.js directly..."
  cd /opt/maintainerr && exec node server.js
elif [ -f /opt/maintainerr/index.js ]; then
  echo "[INFO] Starting index.js..."
  cd /opt/maintainerr && exec node index.js
elif [ -f /opt/maintainerr/package.json ]; then
  echo "[INFO] Starting with NPM..."
  cd /opt/maintainerr && exec npm start
else
  echo "[INFO] Trying default init..."
  # As last resort, try the original init script
  # but only if we're running as PID 1
  if [ -f /init ] && [ "$$" = "1" ]; then
    echo "[INFO] Running original init script..."
    exec /init
  else
    echo "[ERROR] Could not find a way to start Maintainerr"
  fi
fi

# Keep the container running for debugging
echo "[INFO] Keeping container alive for debugging..."
tail -f /dev/null
