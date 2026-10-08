FROM minlag/mermaid-cli:latest

RUN apk add --no-cache make

WORKDIR /data
