FROM secretflow/ubuntu-base-ci:latest

ARG TARGETPLATFORM

ARG GO_VERSION=1.22.4

# install go
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; \
    then \
        GO_ARCH=arm64 && \
        GO_SHA256SUM=a8e177c354d2e4a1b61020aca3562e27ea3e8f8247eca3170e3fa1e0c2f9e771 ; \
    else \
        GO_ARCH=amd64 && \
        GO_SHA256SUM=ba79d4526102575196273416239cca418a651e049c2b099f3159db85e7bade7d ; \
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

