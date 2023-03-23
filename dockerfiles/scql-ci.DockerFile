FROM secretflow/spu-ci:0.3

ARG GO_VERSION=1.19.7
ARG GO_SHA256SUM="7a75720c9b066ae1750f6bcc7052aba70fa3813f4223199ee2a2315fd3eb533d"

# install go
RUN set -eux; \
    url="https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;
