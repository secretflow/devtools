FROM secretflow/spu-ci:0.3

ARG GO_VERSION=1.19.6
ARG GO_SHA256SUM="e3410c676ced327aec928303fef11385702a5562fd19d9a1750d5a2979763c3d"

# install go
RUN set -eux; \
    url="https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

