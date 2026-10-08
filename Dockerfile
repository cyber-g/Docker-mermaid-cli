FROM minlag/mermaid-cli:latest

# apk needs root privileges to install packages.
USER root
RUN apk add --no-cache make

# Keep the base image's unprivileged runtime user.
USER mermaidcli

# The working directory for the Mermaid CLI container.
WORKDIR /data
