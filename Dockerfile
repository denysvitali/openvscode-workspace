FROM gitpod/openvscode-server:latest
ARG GO_VERSION=1.24.0

USER root

RUN apt-get update && \
    apt-get install -y \ 
        wget \
        tar \
        python3 \
    && \
    if [ "$(uname -m)" = "x86_64" ]; then \
        ARCH="amd64"; \
    elif [ "$(uname -m)" = "aarch64" ]; then \
        ARCH="arm64"; \
    else \
        echo "Unsupported architecture"; exit 1; \
    fi && \
    wget -q https://golang.org/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-${ARCH}.tar.gz && \
    rm go${GO_VERSION}.linux-${ARCH}.tar.gz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"

RUN git clone https://aur.archlinux.org/code-features.git /usr/share/code-features && \
    cd /usr/share/code-features && \
    sed -i 's@product_path = "/usr/lib/code/product.json"@product_path = "/home/.openvscode-server/product.json"@' patch.py && \
    python3 patch.py code-features patch
USER openvscode-server
