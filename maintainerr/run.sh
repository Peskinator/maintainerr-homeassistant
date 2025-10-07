#!/usr/bin/with-contenv bash

# Use bashio for logging and config access
source /usr/lib/bashio/bashio.sh

bashio::log.info "Starting Maintainerr..."

# Read user-configured options
export TZ=$(bashio::config 'TZ')
export API_PORT=$(bashio::config 'API_PORT')
export DATA_DIR=/data

# Ensure persistent data directory exists and create symlink
mkdir -p /data
ln -s /data /opt/data

bashio::log.info "Data directory linked to /data for persistence."

# Start the application
# The binary is typically in /opt/maintainerr/
exec /opt/maintainerr/maintainerr
