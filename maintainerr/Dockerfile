ARG BUILD_FROM=ghcr.io/jorenn92/maintainerr:latest
FROM ${BUILD_FROM}

# Copy entry script into s6 init directory
COPY --chmod=755 run.sh /etc/cont-init.d/run.sh
