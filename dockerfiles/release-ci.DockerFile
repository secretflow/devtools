FROM --platform=linux/amd64 centos:centos7
FROM --platform=linux/arm64 centos:centos8

ARG TARGETPLATFORM

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] ; then yum install -y centos-release-scl epel-release \
    && yum update -y \
    && yum clean all \
; fi

RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then cd /etc/yum.repos.d/ \
    && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
    && yum update -y \
    && yum install -y dnf-plugins-core \
    && yum config-manager --set-enabled powertools \
    && yum clean all \
; f

# install devtools and [enable it](https://access.redhat.com/solutions/527703)
RUN yum install -y \
    git vim-common wget unzip which java-11-openjdk-devel \
    libtool autoconf make ninja-build \
    && yum clean all

# install conda
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then CONDA_ARCH=aarch64 ; else CONDA_ARCH=x86_64 ; fi \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$CONDA_ARCH.sh \
    && bash Miniconda3-latest-Linux-$CONDA_ARCH.sh -b \
    && rm -f Miniconda3-latest-Linux-$CONDA_ARCH.sh \
    && /root/miniconda3/bin/conda init

# Install lld
RUN /root/miniconda3/bin/conda install -c conda-forge lld nasm cmake gxx==11.4.0 -y

# install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# install go
ARG GO_VERSION=1.21.4

# install go
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then GO_ARCH=arm64 ; else GO_ARCH=amd64 ; fi \
    url="https://golang.google.cn/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

# install bazel 
RUN wget https://github.com/bazelbuild/bazelisk/releases/download/v1.19.0/bazelisk-linux-amd64 \
    && mv bazelisk-linux-amd64 /usr/bin/bazel \
    && chmod +x /usr/bin/bazel 

# Add conda to path
ENV PATH="/root/miniconda3/bin:${PATH}"

# run as root for now
WORKDIR /home/admin/

ENTRYPOINT [ "/bin/bash", "-l" ]
