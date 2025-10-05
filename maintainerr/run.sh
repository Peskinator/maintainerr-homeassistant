#!/usr/bin/with-contenv bashio

bashio::log.info "Starting Maintainerr..."

# Read user-configured options
TZ=$(bashio::config 'TZ')
API_PORT=$(bashio::config 'API_PORT')

# Export environment variables
export TZ
export API_PORT

# Ensure persistent config directory exists
mkdir -p /data

# Try to create symlink if it doesn't exist
if [ ! -L /opt/data ]; then
    bashio::log.info "Creating symlink from /opt/data to /data"
    rm -rf /opt/data 2>/dev/null || true
    ln -sf /data /opt/data 2>/dev/null || bashio::log.warning "Could not create symlink, using CONFIG_PATH instead"
fi

# Set config path as fallback
export CONFIG_PATH=/data

# Start the application
exec npm start
