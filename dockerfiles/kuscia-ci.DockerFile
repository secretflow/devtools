FROM ubuntu:jammy

LABEL maintainer="secretflow-contact@service.alipay.com"

# change dash to bash as default shell
RUN ln -sf /usr/bin/bash /bin/sh

ARG GO_VERSION=1.19.7
ARG GO_SHA256SUM="7a75720c9b066ae1750f6bcc7052aba70fa3813f4223199ee2a2315fd3eb533d"

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y git wget unzip \
    && apt-get clean

# install bazel 
RUN wget https://github.com/bazelbuild/bazel/releases/download/5.4.1/bazel-5.4.1-installer-linux-x86_64.sh \
    && bash ./bazel-5.4.1-installer-linux-x86_64.sh && rm -f ./bazel-5.4.1-installer-linux-x86_64.sh

# install go
RUN set -eux; \
    url="https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
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
