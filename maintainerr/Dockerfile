ARG BUILD_FROM
FROM ghcr.io/jorenn92/maintainerr:latest

USER root

# Copy our startup wrapper
COPY --chmod=755 run.sh /run.sh

# Use our wrapper as container entrypoint
CMD ["/run.sh"]
