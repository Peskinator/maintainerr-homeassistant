#!/usr/bin/with-contenv bashio
set -e

bashio::log.info "Starting Maintainerr (Home Assistant Add-on Wrapper)..."

# Read user-configured options
TZ=$(bashio::config 'TZ')
API_PORT=$(bashio::config 'API_PORT')

export TZ
export API_PORT

# Prepare persistent directory
bashio::log.info "Preparing persistent data directory..."
mkdir -p /data/maintainerr
chmod -R 777 /data/maintainerr || true

# Remove the ephemeral /opt/data (Docker volume) and replace it with a symlink
if [ -L /opt/data ] || [ -d /opt/data ]; then
    rm -rf /opt/data || true
fi

ln -s /data/maintainerr /opt/data
bashio::log.info "Linked /opt/data -> /data/maintainerr (persistent)"

# Finally, start the original supervisord process that runs Maintainerr
bashio::log.info "Launching Maintainerr via supervisord..."
exec /usr/bin/supervisord -c /etc/supervisord.conf
