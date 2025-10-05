#!/usr/bin/with-contenv bashio

bashio::log.info "Starting Maintainerr (Home Assistant Add-on Wrapper)..."

# Read HA config options
TZ=$(bashio::config 'TZ')
API_PORT=$(bashio::config 'API_PORT')
export TZ
export API_PORT

# Persistent storage
if [ ! -d /data/maintainerr ]; then
    mkdir -p /data/maintainerr
fi

# Link /opt/data to persistent volume
rm -rf /opt/data
ln -s /data/maintainerr /opt/data
bashio::log.info "Linked /opt/data -> /data/maintainerr (persistent)"

# Launch Maintainerr
cd /opt/maintainerr
bashio::log.info "Launching Maintainerr..."
exec npm start -- --port ${API_PORT:-6246}
