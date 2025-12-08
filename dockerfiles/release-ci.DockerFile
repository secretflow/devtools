FROM quay.io/pypa/manylinux_2_28_x86_64:latest

RUN yum install -y \
    git vim-common wget unzip which java-11-openjdk-devel patch \
    libtool autoconf make ninja-build ca-certificates libarchive \
    && yum clean all

# install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda.sh \
    && bash Miniconda.sh -b \
    && rm -f Miniconda.sh \
    && /root/miniconda3/bin/conda init

# Install mamba
RUN CONDA_PLUGINS_AUTO_ACCEPT_TOS=yes /root/miniconda3/bin/conda install mamba -c conda-forge --force-reinstall -y

# Add conda to path
ENV PATH="/root/miniconda3/bin:${PATH}"

# install uv
RUN curl -sL https://astral.sh/uv/install.sh -o uv_install.sh \
    && sh uv_install.sh \
    && rm -f uv_install.sh

# Install lld
RUN /root/miniconda3/bin/conda install -c conda-forge perl lld nasm cmake gxx==11.4.0 -y \
    && /root/miniconda3/bin/conda clean -afy

# install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# install go
ARG GO_VERSION=1.23.1
ARG GO_SHA256SUM="49bbb517cfa9eee677e1e7897f7cf9cfdbcf49e05f61984a2789136de359f9bd"
RUN url="https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

# install bazel
RUN wget https://github.com/bazelbuild/bazelisk/releases/download/v1.25.0/bazelisk-linux-amd64 \
    && mv bazelisk-linux-amd64 /usr/bin/bazelisk \
    && chmod +x /usr/bin/bazelisk \
    && ln -s /usr/bin/bazelisk /usr/bin/bazel

# run as root for now
WORKDIR /home/admin/

ENTRYPOINT [ "/bin/bash", "-lc" ]
