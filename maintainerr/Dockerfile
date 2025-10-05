# Use Home Assistant base image for proper s6 overlay support
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Switch to root to modify filesystem
USER root

# Install dependencies
RUN apk add --no-cache nodejs npm

# Copy our run script into image root
COPY --chmod=755 run.sh /run.sh

# Pull Maintainerr from original upstream image
# (We extract only its /app and dependencies)
RUN mkdir -p /opt/maintainerr && \
    cd /opt/maintainerr && \
    npm install maintainerr -g

# Make sure data directory exists
RUN mkdir -p /data/maintainerr

# Default workdir
WORKDIR /opt/maintainerr

# Ensure script is executable
RUN chmod +x /run.sh

# Run script at container start
CMD [ "/run.sh" ]
