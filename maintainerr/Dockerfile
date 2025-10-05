ARG BUILD_FROM
FROM ghcr.io/jorenn92/maintainerr:latest

# Copy entry script with executable permissions
COPY --chmod=755 run.sh /run.sh

# Run entry script
CMD [ "/run.sh" ]
