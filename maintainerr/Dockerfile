ARG BUILD_FROM
FROM ghcr.io/jorenn92/maintainerr:latest

# Remove the original /opt/data directory
USER root
RUN rm -rf /opt/data || true

# Copy entry script
COPY --chmod=755 run.sh /run.sh

CMD [ "/run.sh" ]
