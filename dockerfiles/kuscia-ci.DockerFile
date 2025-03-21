FROM ubuntu:jammy

LABEL maintainer="secretflow-contact@service.alipay.com"

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# change dash to bash as default shell
RUN ln -sf /usr/bin/bash /bin/sh

ARG TARGETPLATFORM
ARG TARGETARCH
ARG GO_VERSION=1.22.5

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y git wget unzip gcc make curl xz-utils python3.11 shellcheck \
    && apt-get clean

# install go
RUN set -eux; \
    if [ "$TARGETPLATFORM" = "linux/arm64" ] ; \
    then \
        GO_SHA256SUM=8d21325bfcf431be3660527c1a39d3d9ad71535fabdf5041c826e44e31642b5a; \
    else \
        GO_SHA256SUM=904b924d435eaea086515bc63235b192ea441bd8c9b198c507e85009e6e4c7f0; \
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

# Fixed: go: all arguments must refer to packages in the same module at the same version (@v1.50.1)
RUN go install github.com/apache/skywalking-eyes/cmd/license-eye@v0.6.1-0.20250110091440-69f34abb75ec

RUN curl -sL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh && \
    sh nodesource_setup.sh && \
    rm -f nodesource_setup.sh && \
    apt-get install -y nodejs && \
    npm config set registry https://registry.npmmirror.com && \
    npm install -g markdownlint-cli --global && \
    npm install -g linkinator@6.1.2 --global

RUN ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    pip install yamllint==1.35.1 && \
    pip install sphinx==6.2.1 && \
    pip install codespell==2.3.0

# run as root for now
WORKDIR /home/admin/

ENTRYPOINT [ "/bin/bash", "-l" ]
