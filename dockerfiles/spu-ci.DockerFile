# Base image contains c++ toolchain and python
# These should be consistant across all Secretflow dockers
FROM secretflow/ubuntu-base-ci:0.4

ARG TARGETPLATFORM

ARG GO_VERSION=1.19.10

# install go
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] ; then GO_ARCH=amd64 ; else GO_ARCH=arm64 ; fi \
    && wget --no-check-certificate -O go.tgz https://golang.google.cn/dl/go${GO_VERSION}.linux-$GO_ARCH.tar.gz \
    && tar -C /usr/local -xzf go.tgz \
    && rm go.tgz

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"
