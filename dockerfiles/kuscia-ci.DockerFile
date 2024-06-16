FROM ubuntu:jammy

LABEL maintainer="secretflow-contact@service.alipay.com"

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# change dash to bash as default shell
RUN ln -sf /usr/bin/bash /bin/sh

ARG TARGETPLATFORM
ARG TARGETARCH
ARG GO_VERSION=1.19.7

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y git wget unzip gcc make curl \
    && apt-get clean

# install go
RUN set -eux; \
    if [ "$TARGETPLATFORM" = "linux/arm64" ] ; \
    then \
        GO_SHA256SUM=071ea7bf386fdd08df524859b878d99fc359e491e7ad65c1c1cc55b67972c882 ; \
    else \
        GO_SHA256SUM=7a75720c9b066ae1750f6bcc7052aba70fa3813f4223199ee2a2315fd3eb533d ; \
    fi \
    && url="https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1 && \
    go install github.com/t-yuki/gocover-cobertura@latest && \
    go install github.com/jstemmer/go-junit-report/v2@latest && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.50.1

# run as root for now
WORKDIR /home/admin/

ENTRYPOINT [ "/bin/bash", "-l" ]