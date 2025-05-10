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

RUN mkdir -p /usr/lib/code && ln -s /home/.openvscode-server/product.json /usr/lib/code/product.json
RUN cd /tmp && \
    wget https://raw.githubusercontent.com/chaotic-aur/packages/f24e806443dc47afe006f1eef6b011fcb9af33c9/vscodium-marketplace/patch.py && \
    sed -i -E 's@PRODUCT_JSON_LOCATION = .*@PRODUCT_JSON_LOCATION = "/usr/lib/code/product.json"@g' patch.py && \
    cat patch.py && \
    python3 patch.py && \
    cat /usr/lib/code/product.json && \
    rm patch.py
USER openvscode-server
