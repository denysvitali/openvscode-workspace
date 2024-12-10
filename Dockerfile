FROM gitpod/openvscode-server:latest

# Add a variable to specify the Go version
ARG GO_VERSION=1.23.4

USER root

# Update the RUN command to download and install Go version specified by GO_VERSION
RUN apt-get update && \
    apt-get install -y wget tar && \
    if [ "$(uname -m)" = "x86_64" ]; then \
        ARCH="amd64"; \
    elif [ "$(uname -m)" = "aarch64" ]; then \
        ARCH="arm64"; \
    else \
        echo "Unsupported architecture"; exit 1; \
    fi && \
    wget https://golang.org/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-${ARCH}.tar.gz && \
    rm go${GO_VERSION}.linux-${ARCH}.tar.gz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"

USER openvscode-server
