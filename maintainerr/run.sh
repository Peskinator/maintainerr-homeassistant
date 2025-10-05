#!/usr/bin/with-contenv bashio

bashio::log.info "Starting Maintainerr..."

# Read user-configured options
TZ=$(bashio::config 'TZ')
API_PORT=$(bashio::config 'API_PORT')

# Export environment variables
export TZ
export API_PORT
export CONFIG_PATH=/data

# Ensure persistent config directory exists
mkdir -p /data

# Start the application
exec npm start
