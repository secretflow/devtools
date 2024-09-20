FROM secretflow/ubuntu-base-ci:latest

ARG TARGETPLATFORM

ARG GO_VERSION=1.23.1

# install go
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; \
    then \
        GO_ARCH=arm64 && \
        GO_SHA256SUM=faec7f7f8ae53fda0f3d408f52182d942cc89ef5b7d3d9f23ff117437d4b2d2f ; \
    else \
        GO_ARCH=amd64 && \
        GO_SHA256SUM=49bbb517cfa9eee677e1e7897f7cf9cfdbcf49e05f61984a2789136de359f9bd ; \
    fi \
    && url="https://golang.google.cn/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

RUN apt update \
    && apt upgrade -y \
    && apt install -y protobuf-compiler \
    && apt clean
