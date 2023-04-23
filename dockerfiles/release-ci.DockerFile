FROM centos:centos7

# GCC version
ARG DEVTOOLSET_VERSION=11

RUN yum install -y centos-release-scl epel-release \
    && yum update -y \
    && yum clean all

# install devtools and [enable it](https://access.redhat.com/solutions/527703)
RUN yum install -y \
    devtoolset-${DEVTOOLSET_VERSION}-gcc \
    devtoolset-${DEVTOOLSET_VERSION}-gcc-c++ \
    devtoolset-${DEVTOOLSET_VERSION}-binutils \
    git vim-common wget unzip which java-11-openjdk-devel.x86_64 \
    libtool autoconf make ninja-build \
    && yum clean all \
    && echo "source scl_source enable devtoolset-${DEVTOOLSET_VERSION}" > /etc/profile.d/enable_gcc_toolset.sh

ENV PATH="/opt/rh/devtoolset-${DEVTOOLSET_VERSION}/root/usr/bin:${PATH}" 

RUN wget --no-check-certificate https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.gz \
    && tar zxf nasm-2.15.05.tar.gz \
    && cd nasm-2.15.05 \
    && ./configure \
    && make install \
    && rm -rf /nasm-2.15.05 \
    && rm -f /nasm-2.15.05.tar.gz

RUN wget https://github.com/Kitware/CMake/releases/download/v3.26.3/cmake-3.26.3-linux-x86_64.sh \
    && sh cmake-3.26.3-linux-x86_64.sh --prefix=/usr --skip-license \
    && rm -f cmake-3.26.3-linux-x86_64.sh

# install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && /root/miniconda3/bin/conda init bash

COPY dockerfiles/build_llvm.sh /tmp/build_llvm.sh
RUN wget --no-check-certificate https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.6/llvm-project-15.0.6.src.tar.xz \
    && tar xf llvm-project-15.0.6.src.tar.xz \
    && cd llvm-project-15.0.6.src/llvm \
    && sh /tmp/build_llvm.sh \
    && rm -rf /llvm-project-15.0.6.src \
    && rm -f /llvm-project-15.0.6.src.tar.xz \
    && rm -f /tmp/build_llvm.sh

# install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# install go
ARG GO_VERSION=1.19.8
ARG GO_SHA256SUM="e1a0bf0ab18c8218805a1003fd702a41e2e807710b770e787e5979d1cf947aba"

# install go
RUN set -eux; \
    url="https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
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

CMD [ "/bin/bash" ]