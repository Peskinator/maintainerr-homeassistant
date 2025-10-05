# Use the official Maintainerr container as the base
ARG BUILD_FROM=ghcr.io/jorenn92/maintainerr:latest
FROM ${BUILD_FROM}

USER root

# Copy our startup script into container
COPY --chmod=755 run.sh /run.sh

# Make sure bash or sh exists
SHELL ["/bin/sh", "-c"]

# Ensure persistent data directory exists
RUN mkdir -p /data/maintainerr

# Override entrypoint so our script runs first
CMD [ "/run.sh" ]
