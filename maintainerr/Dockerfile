ARG BUILD_FROM=ghcr.io/jorenn92/maintainerr:latest
FROM ${BUILD_FROM}

# Copy the run script and set executable permission at the same time
COPY --chmod=755 run.sh /run.sh

# Set the command to run our script on startup
CMD [ "/run.sh" ]
RUN rm -rf /opt/data && ln -s /data /opt/data
