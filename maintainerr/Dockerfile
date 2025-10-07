ARG BUILD_FROM
FROM ghcr.io/jorenn92/maintainerr:latest

# Copy entry script
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
RUN rm -rf /opt/data && ln -s /data /opt/data

# Run entry script
CMD [ "/run.sh" ]
