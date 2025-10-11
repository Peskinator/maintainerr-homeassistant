#!/usr/bin/env sh
set -e

echo "[ha-addon] Starting Maintainerr (HA persistence wrapper)..."

PERSIST="/data"
SRC="/opt/data"

# Ensure persistent dir exists
mkdir -p "$PERSIST"
# Ensure parent for /opt/data exists
mkdir -p "$(dirname "$SRC")"

# Ensure persist targets exist
mkdir -p "$PERSIST/logs"
touch "$PERSIST/maintainerr.sqlite" 2>/dev/null || true

# Make writable for the app user (node) if present
if id node >/dev/null 2>&1; then
  chown -R node:node "$PERSIST" 2>/dev/null || true
else
  chmod -R 0777 "$PERSIST" 2>/dev/null || true
fi

# Inside the upstream /opt/data mount, link specific payloads to /data
# Database file
if [ -e "$SRC/maintainerr.sqlite" ] && [ ! -L "$SRC/maintainerr.sqlite" ]; then
  rm -f "$SRC/maintainerr.sqlite" 2>/dev/null || true
fi
ln -snf "$PERSIST/maintainerr.sqlite" "$SRC/maintainerr.sqlite"

# Logs directory
if [ -e "$SRC/logs" ] && [ ! -L "$SRC/logs" ]; then
  rm -rf "$SRC/logs" 2>/dev/null || true
fi
ln -snf "$PERSIST/logs" "$SRC/logs"

echo "[ha-addon] Linked payloads: $SRC/maintainerr.sqlite -> $PERSIST/maintainerr.sqlite, $SRC/logs -> $PERSIST/logs"

# Helpful envs for apps that honor them
export CONFIG_PATH="$PERSIST"
export XDG_CONFIG_HOME="$PERSIST"
export XDG_DATA_HOME="$PERSIST"
export DATA_DIR="$PERSIST"
export DATA_PATH="$PERSIST"
export APP_DATA_DIR="$PERSIST"
export MAINTAINERR_DATA_DIR="$PERSIST"

# Chain to upstream supervisor (foreground)
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
