#!/bin/sh

echo "[INFO] Starting Maintainerr (HA Wrapper)..."

# Read environment vars if set
TZ=${TZ:-Europe/Brussels}
API_PORT=${API_PORT:-6246}
export TZ
export API_PORT

# Ensure persistent storage
mkdir -p /data/maintainerr

# Link /opt/data -> /data/maintainerr
rm -rf /opt/data
ln -s /data/maintainerr /opt/data
echo "[INFO] Linked /opt/data -> /data/maintainerr (persistent)"

# Run Maintainerr
cd /app || exit 1

echo "[INFO] Launching Maintainerr on port $API_PORT..."
exec node dist/main.js --port "$API_PORT"
