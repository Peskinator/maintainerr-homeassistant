#!/usr/bin/env sh
set -e

echo "[ha-addon] Starting Maintainerr (HA persistence wrapper)..."

PERSIST="/data"
SRC="/opt/data"
CONFIG_DIR="/config/addons_config/maintainerr"

# Ensure mounts/dirs exist
mkdir -p "$PERSIST"
mkdir -p "$(dirname "$SRC")"

# Detect if /config is mounted and writable
CONFIG_READY=0
if grep -qs " /config " /proc/mounts; then
  if sh -c 'touch /config/.ha_addon_w 2>/dev/null && rm -f /config/.ha_addon_w 2>/dev/null'; then
    CONFIG_READY=1
  fi
fi

if [ "$CONFIG_READY" -eq 1 ]; then
  # Prepare mirror under /config/addons_config/maintainerr
  mkdir -p "/config/addons_config" "$CONFIG_DIR" "$CONFIG_DIR/logs"
  touch "$CONFIG_DIR/maintainerr.sqlite" 2>/dev/null || true

  # Permissions for app user
  if id node >/dev/null 2>&1; then
    chown -R node:node "$CONFIG_DIR" 2>/dev/null || true
  else
    chmod -R 0777 "$CONFIG_DIR" 2>/dev/null || true
  fi

  # Point upstream payloads at /config/addons_config/maintainerr
  if [ -e "$SRC/maintainerr.sqlite" ] && [ ! -L "$SRC/maintainerr.sqlite" ]; then
    rm -f "$SRC/maintainerr.sqlite" 2>/dev/null || true
  fi
  ln -snf "$CONFIG_DIR/maintainerr.sqlite" "$SRC/maintainerr.sqlite"

  if [ -e "$SRC/logs" ] && [ ! -L "$SRC/logs" ]; then
    rm -rf "$SRC/logs" 2>/dev/null || true
  fi
  ln -snf "$CONFIG_DIR/logs" "$SRC/logs"

  echo "[ha-addon] Using $CONFIG_DIR for DB/logs (linked into $SRC)"
else
  echo "[ha-addon] /config not mounted/writable; skipping mirror creation"
fi

# Environment hints
if [ "$CONFIG_READY" -eq 1 ]; then
  export CONFIG_PATH="$CONFIG_DIR"
  export XDG_CONFIG_HOME="$CONFIG_DIR"
  export XDG_DATA_HOME="$CONFIG_DIR"
  export DATA_DIR="$CONFIG_DIR"
  export DATA_PATH="$CONFIG_DIR"
  export APP_DATA_DIR="$CONFIG_DIR"
  export MAINTAINERR_DATA_DIR="$CONFIG_DIR"
else
  export CONFIG_PATH="$PERSIST"
  export XDG_CONFIG_HOME="$PERSIST"
  export XDG_DATA_HOME="$PERSIST"
  export DATA_DIR="$PERSIST"
  export DATA_PATH="$PERSIST"
  export APP_DATA_DIR="$PERSIST"
  export MAINTAINERR_DATA_DIR="$PERSIST"
fi

# Start upstream supervisor (foreground)
if [ -x /usr/bin/supervisord ]; then
  if [ -f /etc/supervisord.conf ]; then
    exec /usr/bin/supervisord -n -c /etc/supervisord.conf
  else
    exec /usr/bin/supervisord -n
  fi
fi

# Fallbacks
if command -v supervisord >/dev/null 2>&1; then
  exec supervisord -n
fi

if command -v npm >/dev/null 2>&1; then
  exec npm start
fi

echo "[ha-addon] No supervisor or npm found; sleeping."
exec tail -f /dev/null
echo "[ha-addon] No supervisor or npm found; sleeping."
exec tail -f /dev/null
