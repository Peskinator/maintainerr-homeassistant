#!/usr/bin/with-contenv bashio

bashio::log.info "Starting Maintainerr..."

# Read user-configured options
TZ=$(bashio::config 'TZ')
API_PORT=$(bashio::config 'API_PORT')

# Export environment variables
export TZ
export API_PORT
export CONFIG_PATH=/data

# Create symbolic links for persistence
bashio::log.info "Creating symlink for data persistence..."
mkdir -p /data
rm -rf /opt/data 2>/dev/null
ln -sf /data /opt/data

# Debug: Find the maintainerr binary
bashio::log.info "Locating Maintainerr binary..."
find / -name maintainerr -type f 2>/dev/null

bashio::log.info "Starting Maintainerr application..."
# Try common paths for the binary - we'll find the right one
if [ -f /app/maintainerr ]; then
  exec /app/maintainerr
elif [ -f /opt/maintainerr/maintainerr ]; then
  exec /opt/maintainerr/maintainerr
else
  # Find the binary and execute it
  BINARY_PATH=$(find / -name maintainerr -type f 2>/dev/null | head -1)
  if [ -n "$BINARY_PATH" ]; then
    bashio::log.info "Found Maintainerr at $BINARY_PATH"
    exec $BINARY_PATH
  else
    bashio::log.error "Could not find Maintainerr binary"
    exit 1
  fi
fi
