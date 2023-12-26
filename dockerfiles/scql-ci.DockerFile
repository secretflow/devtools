FROM secretflow/ubuntu-base-ci:20231208

ARG GO_VERSION=1.21.5
ARG GO_SHA256SUM="e2bc0b3e4b64111ec117295c088bde5f00eeed1567999ff77bc859d7df70078e"

# install go
RUN set -eux; \
    url="https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"
