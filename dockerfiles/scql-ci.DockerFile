FROM secretflow/spu-ci:0.8

ARG GO_VERSION=1.19.12
ARG GO_SHA256SUM="48e4fcfb6abfdaa01aaf1429e43bdd49cea5e4687bd5f5b96df1e193fcfd3e7e"

# install go
RUN set -eux; \
    url="https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"
