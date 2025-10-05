#!/usr/bin/with-contenv bashio

bashio::log.info "Starting Maintainerr..."

# Read user-configured options
TZ=$(bashio::config 'TZ')
API_PORT=$(bashio::config 'API_PORT')

# Export environment variables
export TZ
export API_PORT

# Ensure directory exists
mkdir -p /config

bashio::log.info "Data directory: $DATA_DIR"

# Start the application
exec npm start
