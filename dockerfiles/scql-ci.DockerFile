FROM secretflow/ubuntu-base-ci:latest

ARG TARGETPLATFORM

ARG GO_VERSION=1.24.0

# install go
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; \
    then \
        GO_ARCH=arm64 && \
        GO_SHA256SUM=c3fa6d16ffa261091a5617145553c71d21435ce547e44cc6dfb7470865527cc7 ; \
    else \
        GO_ARCH=amd64 && \
        GO_SHA256SUM=dea9ca38a0b852a74e81c26134671af7c0fbe65d81b0dc1c5bfe22cf7d4c8858 ; \
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
