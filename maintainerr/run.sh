#!/bin/sh

echo "[INFO] Setting up Maintainerr persistence..."

# Read user-configured options from environment
# Home Assistant will set these from config.yaml
TZ="${TZ:-Europe/Brussels}"
API_PORT="${API_PORT:-6246}"

# Export environment variables for the application
export TZ
export API_PORT
export DATA_DIR="/data"
export CONFIG_PATH="/data"

# Create symbolic link for persistence
mkdir -p /data
rm -rf /opt/data 2>/dev/null
ln -sf /data /opt/data

echo "[INFO] Persistence configured: /opt/data -> /data"

# No need to start the application here as this is a cont-init.d script
# The original container's init system will start the app automatically
exit 0
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
