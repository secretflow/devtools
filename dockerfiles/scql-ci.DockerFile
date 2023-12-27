FROM secretflow/ubuntu-base-ci:latest

ARG TARGETPLATFORM

ARG GO_VERSION=1.21.5

# install go
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; \
    then \
        GO_ARCH=arm64 && \
        GO_SHA256SUM=841cced7ecda9b2014f139f5bab5ae31785f35399f236b8b3e75dff2a2978d96 ; \
    else \
        GO_ARCH=amd64 && \
        GO_SHA256SUM=e2bc0b3e4b64111ec117295c088bde5f00eeed1567999ff77bc859d7df70078e ; \
    fi \
    && url="https://golang.google.cn/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"
