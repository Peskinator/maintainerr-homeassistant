#!/usr/bin/with-contenv bashio

bashio::log.info "Preparing persistent storage for Maintainerr..."

# Prepare persistent path
mkdir -p /data/maintainerr

# Create symlink for persistence
ln -sf /data/maintainerr /opt/data

bashio::log.info "Linked /opt/data -> /data/maintainerr (persistent)"

# Exit successfully
exit 0
