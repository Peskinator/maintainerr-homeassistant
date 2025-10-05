#!/usr/bin/with-contenv bashio

bashio::log.info "Starting Maintainerr..."

# Read user-configured options
TZ=$(bashio::config 'TZ')
API_PORT=$(bashio::config 'API_PORT')

export TZ
export API_PORT

# Create symlink from /opt/data to persistent /data
mkdir -p /data/maintainerr
ln -sf /data/maintainerr /opt/data
bashio::log.info "Linked /opt/data -> /data/maintainerr"

exec npm start
