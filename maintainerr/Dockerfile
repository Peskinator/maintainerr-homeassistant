ARG BUILD_FROM
FROM ghcr.io/jorenn92/maintainerr:latest

# Copy entry script with executable permissions already set
COPY --chmod=755 run.sh /run.sh

# Redirect /opt/data to /data (which Home Assistant maps)
RUN rm -rf /opt/data && ln -s /data /opt/data

# Run entry script
CMD [ "/run.sh" ]
