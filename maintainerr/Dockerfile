ARG BUILD_FROM
FROM ghcr.io/jorenn92/maintainerr:latest

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Backup supervisord config for reference (optional, useful for debugging)
RUN cp /etc/supervisord.conf /etc/supervisord.conf.bak || true

# Copy our startup wrapper
COPY --chmod=755 run.sh /run.sh

# Use our wrapper as container entrypoint
CMD ["/run.sh"]
