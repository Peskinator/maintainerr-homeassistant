ARG BUILD_FROM
FROM ghcr.io/jorenn92/maintainerr:latest

# Override the DATA_DIR environment variable
ENV DATA_DIR=/config

# Copy entry script with executable permissions
COPY --chmod=755 run.sh /run.sh

# Run entry script
CMD [ "/run.sh" ]
