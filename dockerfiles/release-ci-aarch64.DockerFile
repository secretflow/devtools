FROM centos:centos8

# GCC version
ARG DEVTOOLSET_VERSION=11

RUN yum update -y \
    && yum install dnf-plugins-core \
    && yum config-manager --set-enabled PowerTools \
    && yum clean all

# install devtools and [enable it](https://access.redhat.com/solutions/527703)
RUN yum install -y \
    devtoolset-${DEVTOOLSET_VERSION}-gcc \
    devtoolset-${DEVTOOLSET_VERSION}-gcc-c++ \
    devtoolset-${DEVTOOLSET_VERSION}-binutils \
    git vim-common wget unzip which java-11-openjdk-devel.aarch64 \
    libtool autoconf make ninja-build \
    && yum clean all \
    && echo "source scl_source enable devtoolset-${DEVTOOLSET_VERSION}" > /etc/profile.d/enable_gcc_toolset.sh

ENV PATH="/opt/rh/devtoolset-${DEVTOOLSET_VERSION}/root/usr/bin:${PATH}" 

RUN wget https://github.com/Kitware/CMake/releases/download/v3.26.3/cmake-3.26.3-linux-aarch64.sh \
    && sh cmake-3.26.3-linux-aarch64.sh --prefix=/usr --skip-license \
    && rm -f cmake-3.26.3-linux-aarch64.sh

# install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh \
    && bash Miniconda3-latest-Linux-aarch64.sh -b \
    && rm -f Miniconda3-latest-Linux-aarch64.sh \
    && /root/miniconda3/bin/conda init bash

# install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# install go
ARG GO_VERSION=1.19.10
ARG GO_SHA256SUM="8b045a483d3895c6edba2e90a9189262876190dbbd21756870cdd63821810677"

# install go
RUN set -eux; \
    url="https://golang.google.cn/dl/go${GO_VERSION}.linux-arm64.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

# install bazel 
RUN wget https://github.com/bazelbuild/bazel/releases/download/5.4.1/bazel-5.4.1-installer-linux-x86_64.sh \
    && bash ./bazel-5.4.1-installer-linux-x86_64.sh && rm -f ./bazel-5.4.1-installer-linux-x86_64.sh

# Add conda to path
ENV PATH="/root/miniconda3/bin:${PATH}"

# run as root for now
WORKDIR /home/admin/

ENTRYPOINT [ "/bin/bash", "-l" ]