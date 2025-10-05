#!/usr/bin/with-contenv sh
set -e

echo "[INFO] Starting Maintainerr (Home Assistant Add-on Wrapper)..."

# Read user-configured options
TZ=$(bashio::config 'TZ')
API_PORT=$(bashio::config 'API_PORT')

export TZ
export API_PORT

echo "[INFO] Preparing persistent data directory..."
mkdir -p /data/maintainerr
chmod -R 777 /data/maintainerr || true

# Remove ephemeral /opt/data and replace with persistent symlink
if [ -L /opt/data ] || [ -d /opt/data ]; then
    rm -rf /opt/data || true
fi

ln -s /data/maintainerr /opt/data
echo "[INFO] Linked /opt/data -> /data/maintainerr (persistent)"

# Launch Maintainerr through supervisord (the base image uses it)
echo "[INFO] Launching Maintainerr via supervisord..."
exec /usr/bin/supervisord -c /etc/supervisord.conf
