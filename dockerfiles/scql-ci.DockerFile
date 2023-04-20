FROM secretflow/spu-ci:0.7

ARG GO_VERSION=1.19.8
ARG GO_SHA256SUM="e1a0bf0ab18c8218805a1003fd702a41e2e807710b770e787e5979d1cf947aba"

# install go
RUN set -eux; \
    url="https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"