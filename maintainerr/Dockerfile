ARG BUILD_FROM=ghcr.io/jorenn92/maintainerr:latest
FROM ${BUILD_FROM}

# Ensure persistence directory exists
RUN mkdir -p /data/maintainerr

# Set environment variable if supported by Maintainerr
ENV MAINTAINERR_DATA_DIR=/data/maintainerr

# Copy run.sh to the correct s6-overlay location
COPY run.sh /etc/services.d/maintainerr/run

# Make the script executable
RUN chmod a+x /etc/services.d/maintainerr/run
