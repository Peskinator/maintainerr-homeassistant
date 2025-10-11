#!/usr/bin/env sh
set -e

echo "[ha-addon] Starting Maintainerr (HA persistence wrapper)..."

PERSIST="/data"
SRC="/opt/data"

# Ensure persistent dir exists
mkdir -p "$PERSIST"
# Ensure parent for /opt/data exists
mkdir -p "$(dirname "$SRC")"

# Make it writable for the app (prefer node user if present)
if id node >/dev/null 2>&1; then
  chown -R node:node "$PERSIST" 2>/dev/null || true
else
  chmod 0777 "$PERSIST" 2>/dev/null || true
fi

# Overlay the upstream volume with our persistent /data using a bind mount
if grep -qs " $SRC " /proc/mounts; then
  echo "[ha-addon] $SRC is already a mount, binding $PERSIST over it..."
fi
# Perform bind mount (BusyBox mount supports -o bind)
mount -o bind "$PERSIST" "$SRC" 2>/dev/null || {
  echo "[ha-addon] bind mount failed, falling back to symlink"
  rm -rf "$SRC" 2>/dev/null || true
  ln -s "$PERSIST" "$SRC" 2>/dev/null || true
}
echo "[ha-addon] Using $SRC -> $PERSIST"

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
