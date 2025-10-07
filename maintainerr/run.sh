#!/usr/bin/with-contenv bashio

# Prepare persistent path
mkdir -p /data/maintainerr

# Create symlink for persistence
ln -sf /data/maintainerr /opt/data

# Exit successfully
exit 0
fi
ln -sf /data/maintainerr /opt/data

bashio::log.info "Linked /opt/data -> /data/maintainerr (persistent)"

# Start Maintainerr
exec /opt/maintainerr/maintainerr
