ARG BUILD_FROM
FROM ghcr.io/jorenn92/maintainerr:latest

USER root

# Copy our startup wrapper
COPY --chmod=755 run.sh /run.sh

# Force our wrapper to run first (even if base image has its own ENTRYPOINT)
ENTRYPOINT ["/run.sh"]
