FROM secretflow/ubuntu-base-ci:latest

ARG TARGETPLATFORM

ARG GO_VERSION=1.22.1

# install go
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; \
    then \
        GO_ARCH=arm64 && \
        GO_SHA256SUM=e56685a245b6a0c592fc4a55f0b7803af5b3f827aaa29feab1f40e491acf35b8 ; \
    else \
        GO_ARCH=amd64 && \
        GO_SHA256SUM=aab8e15785c997ae20f9c88422ee35d962c4562212bb0f879d052a35c8307c7f ; \
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

