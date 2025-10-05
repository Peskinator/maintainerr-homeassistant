#!/usr/bin/with-contenv bashio

bashio::log.info "Starting Maintainerr..."

# Read user-configured options
TZ=$(bashio::config 'TZ')
API_PORT=$(bashio::config 'API_PORT')

# Export environment variables
export TZ
export API_PORT

# Point Maintainerr to use the addon_config location
export DATA_DIR=/config

# Ensure directory exists
mkdir -p /config

bashio::log.info "Data directory set to: /config"

# Start the application
exec npm start
