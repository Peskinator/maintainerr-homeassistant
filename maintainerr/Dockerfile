ARG BUILD_FROM
FROM ghcr.io/maintainerr/maintainerr

# Copy entry script with executable permissions
COPY --chmod=755 run.sh /run.sh

# Run wrapper as root so it can prepare /data
USER root

# Ensure our wrapper runs first and then chains to upstream
ENTRYPOINT [ "/run.sh" ]
