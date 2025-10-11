#!/usr/bin/env sh
set -e

echo "[ha-addon] Starting Maintainerr (HA persistence wrapper)..."

PERSIST="/data"
SRC="/opt/data"

# Ensure persistent dir exists
mkdir -p "$PERSIST"

# Make it writable for the app (prefer node user if present)
if id node >/dev/null 2>&1; then
  chown -R node:node "$PERSIST" 2>/dev/null || true
else
  chmod 0777 "$PERSIST" 2>/dev/null || true
fi

# Replace /opt/data with symlink to /data (no migration)
rm -rf "$SRC" 2>/dev/null || true
ln -s "$PERSIST" "$SRC" 2>/dev/null || true
echo "[ha-addon] Linked $SRC -> $PERSIST"

# Helpful envs for apps that honor them
export CONFIG_PATH="$PERSIST"
export XDG_CONFIG_HOME="$PERSIST"
export XDG_DATA_HOME="$PERSIST"

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
fi

if command -v npm >/dev/null 2>&1; then
  exec npm start
fi

echo "[ha-addon] No supervisor or npm found; sleeping."
exec tail -f /dev/null
