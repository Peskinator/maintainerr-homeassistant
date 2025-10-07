ARG BUILD_FROM=ghcr.io/jorenn92/maintainerr:latest
FROM ${BUILD_FROM}

# Copy initialization script to s6-overlay directory
COPY run.sh /etc/cont-init.d/00-maintainerr
RUN chmod a+x /etc/cont-init.d/00-maintainerr
# Set environment variable if supported by Maintainerr
ENV MAINTAINERR_DATA_DIR=/data/maintainerr

# Copy run.sh to the correct s6-overlay location
COPY run.sh /etc/services.d/maintainerr/run

# Make the script executable
RUN chmod a+x /etc/services.d/maintainerr/run
