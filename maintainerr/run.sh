#!/usr/bin/with-contenv bashio

bashio::log.info "Preparing persistent storage for Maintainerr..."

# Prepare persistent path
mkdir -p /data/maintainerr

# Replace ephemeral /opt/data with a symlink
if [ -d /opt/data ]; then
    rm -rf /opt/data
fi
ln -sf /data/maintainerr /opt/data

bashio::log.info "Linked /opt/data -> /data/maintainerr (persistent)"

# Start Maintainerr
exec /opt/maintainerr/maintainerr
