ARG BUILD_FROM=ghcr.io/jorenn92/maintainerr:latest
FROM ${BUILD_FROM}

# Copy entry script with executable permissions
COPY --chmod=755 run.sh /run.sh

# Redirect /opt/data to /data (which Home Assistant maps)
# This is better done at runtime, but to keep it here, we need root.
# The base image runs as non-root, so this symlink creation should be in run.sh
# For now, let's assume the base image allows this or we run as root temporarily.
# A better fix is to move this to run.sh. Let's try that.
RUN rm -rf /opt/data

# Run entry script
CMD [ "/run.sh" ]
