# Base image contains c++ toolchain and python
# These should be consistant across all Secretflow dockers
FROM secretflow/ubuntu-base-ci:0.1

ARG GO_VERSION=1.19.7

# Required by grpc
# install go
RUN set -eux; \
    url="https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "c9c08f783325c4cf840a94333159cc937f05f75d36a8b307951d5bd959cf2ab8 *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"
