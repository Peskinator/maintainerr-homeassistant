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

# According to Home Assistant docs, use the simplest approach first
if [ -d /opt/maintainerr ]; then
  echo "[INFO] Starting from /opt/maintainerr..."
  cd /opt/maintainerr && exec npm start
elif [ -d /opt/app ]; then
  echo "[INFO] Starting from /opt/app..."
  cd /opt/app && exec npm start
elif [ -d /app ]; then
  echo "[INFO] Starting from /app..."
  cd /app && exec npm start
elif [ -d /opt ]; then
  echo "[INFO] Starting from /opt..."
  cd /opt && exec npm start
else
  echo "[ERROR] Could not find application directory"
  echo "[INFO] Directory listing to help debug:"
  ls -la /
  ls -la /opt 2>/dev/null
  ls -la /app 2>/dev/null
  exit 1
fi
  else
    echo "[ERROR] Could not find a way to start Maintainerr"
  fi
fi

# Keep the container running for debugging
echo "[INFO] Keeping container alive for debugging..."
tail -f /dev/null
