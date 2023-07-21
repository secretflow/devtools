FROM secretflow/spu-ci:0.8

ARG GO_VERSION=1.19.10
ARG GO_SHA256SUM="8b045a483d3895c6edba2e90a9189262876190dbbd21756870cdd63821810677"

# install go
RUN set -eux; \
    url="https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

ENTRYPOINT ["/bin/bash", "-l", "-c"] 
