FROM centos:centos8

# GCC version
ARG DEVTOOLSET_VERSION=11

RUN cd /etc/yum.repos.d/ \
    && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum update -y \
    && yum install -y dnf-plugins-core \
    && yum clean all

RUN yum config-manager --set-enabled powertools

# install devtools and [enable it](https://access.redhat.com/solutions/527703)
RUN yum install -y \
    gcc-toolset-${DEVTOOLSET_VERSION}-gcc \
    gcc-toolset-${DEVTOOLSET_VERSION}-gcc-c++ \
    gcc-toolset-${DEVTOOLSET_VERSION}-binutils \
    git vim-common wget unzip which java-11-openjdk-devel.aarch64 \
    libtool autoconf make ninja-build \
    && yum clean all \
    && echo "source scl_source enable devtoolset-${DEVTOOLSET_VERSION}" > /etc/profile.d/enable_gcc_toolset.sh

ENV PATH="/opt/rh/gcc-toolset-${DEVTOOLSET_VERSION}/root/usr/bin:${PATH}" 

RUN wget https://github.com/Kitware/CMake/releases/download/v3.26.3/cmake-3.26.3-linux-aarch64.sh \
    && sh cmake-3.26.3-linux-aarch64.sh --prefix=/usr --skip-license \
    && rm -f cmake-3.26.3-linux-aarch64.sh

# install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh \
    && bash Miniconda3-latest-Linux-aarch64.sh -b \
    && rm -f Miniconda3-latest-Linux-aarch64.sh \
    && /root/miniconda3/bin/conda init bash

# install go
ARG GO_VERSION=1.19.10
ARG GO_SHA256SUM="df98698821211c819e8b2420c77a0f802d989e377718578a31b1f91f6be2c5b4"

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
RUN wget https://github.com/bazelbuild/bazel/releases/download/5.4.1/bazel-5.4.1-linux-arm64 \
    && mv bazel-5.4.1-linux-arm64 /usr/bin/bazel \
    && chmod +x /usr/bin/bazel

# Add conda to path
ENV PATH="/root/miniconda3/bin:${PATH}"

# run as root for now
WORKDIR /home/admin/

ENTRYPOINT [ "/bin/bash", "-l" ]