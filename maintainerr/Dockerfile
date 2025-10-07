# Base on official Maintainerr image (includes s6-overlay)
ARG BUILD_FROM=ghcr.io/jorenn92/maintainerr:latest
FROM ${BUILD_FROM}

# Ensure persistence directory exists
RUN mkdir -p /data/maintainerr

# Set environment variable if supported by Maintainerr
ENV MAINTAINERR_DATA_DIR=/data/maintainerr

# Copy our startup script that will run before the app
COPY --chmod=755 run.sh /etc/cont-init.d/10-persistent-data.sh

# Ensure persistence directory exists
RUN mkdir -p /data/maintainerr
RUN mkdir -p /data/maintainerr
