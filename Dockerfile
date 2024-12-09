FROM gitpod/openvscode-server:latest
USER root
RUN apt-get update && \
    apt-get install -y golang && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
USER openvscode-server
