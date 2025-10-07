# Base on official Maintainerr image (includes s6-overlay)
ARG BUILD_FROM=ghcr.io/jorenn92/maintainerr:latest
FROM ${BUILD_FROM}

# Copy our startup script that will run before the app
COPY --chmod=755 run.sh /etc/cont-init.d/00-persistent-data.sh

# Ensure persistence directory exists
RUN mkdir -p /data/maintainerr

# Nothing else to override; s6 will start Maintainerr as usual
RUN mkdir -p /data/maintainerr

# Nothing else to override; s6 will start Maintainerr as usual
