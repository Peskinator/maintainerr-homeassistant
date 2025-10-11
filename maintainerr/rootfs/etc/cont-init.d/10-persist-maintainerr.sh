#!/usr/bin/with-contenv bash
set -euo pipefail

PERSIST_DIR="/data/maintainerr"
mkdir -p "$PERSIST_DIR"

# If the add-on honors PUID/PGID, try to apply them; otherwise ignore errors.
chown -R "${PUID:-0}:${PGID:-0}" "$PERSIST_DIR" 2>/dev/null || true

# Candidate locations where Maintainerr may store its data/config.
# We avoid touching generic HA mounts like /config.
CANDIDATES=(
  "/app/data"
  "/app/config"
  "/usr/src/app/data"
  "/usr/src/app/config"
  "/home/node/.config/maintainerr"
  "/root/.config/maintainerr"
)

for SRC in "${CANDIDATES[@]}"; do
  if [ -d "$SRC" ] && [ ! -L "$SRC" ]; then
    # If destination is empty and source has files, migrate once.
    if [ -z "$(ls -A "$PERSIST_DIR" 2>/dev/null)" ] && [ -n "$(ls -A "$SRC" 2>/dev/null)" ]; then
      echo "[maintainerr] Migrating data from $SRC to $PERSIST_DIR ..."
      # Prefer cp -aT to preserve perms; fallback if unavailable.
      if cp -aT "$SRC" "$PERSIST_DIR" 2>/dev/null; then
        :
      else
        # BusyBox fallback
        cp -a "$SRC"/. "$PERSIST_DIR"/
      fi
    fi
    rm -rf "$SRC"
    ln -s "$PERSIST_DIR" "$SRC"
    echo "[maintainerr] Linked $SRC -> $PERSIST_DIR"
  fi
done

# Persist environment for the service via s6 container environment.
mkdir -p /var/run/s6/container_environment
printf %s "/data/maintainerr" > /var/run/s6/container_environment/XDG_CONFIG_HOME
printf %s "/data/maintainerr" > /var/run/s6/container_environment/XDG_DATA_HOME

echo "[maintainerr] Persistence setup complete."
