FROM centos:centos7 

RUN yum install -y centos-release-scl epel-release \
    && yum update -y \
    && yum clean all

RUN yum install -y \
    git vim-common wget unzip which java-11-openjdk-devel \
    libtool autoconf make ninja-build perl-IPC-Cmd \
    && yum clean all

# install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py310_24.1.2-0-Linux-x86_64.sh \
    && bash Miniconda3-py310_24.1.2-0-Linux-x86_64.sh -b \
    && rm -f Miniconda3-py310_24.1.2-0-Linux-x86_64.sh \
    && /root/miniconda3/bin/conda init

RUN conda config --remove channels defaults \
    && conda config --add channels conda-forge \
    && conda update --all --solver classic

# Add conda to path
ENV PATH="/root/miniconda3/bin:${PATH}"

# Install lld
RUN /root/miniconda3/bin/conda install -c conda-forge lld nasm cmake gxx==11.4.0 -y \
    && /root/miniconda3/bin/conda clean -afy

# install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# install go
ARG GO_VERSION=1.22.1
ARG GO_SHA256SUM="aab8e15785c997ae20f9c88422ee35d962c4562212bb0f879d052a35c8307c7f"
RUN url="https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

# install bazel 
RUN wget https://github.com/bazelbuild/bazelisk/releases/download/v1.19.0/bazelisk-linux-amd64 \
    && mv bazelisk-linux-amd64 /usr/bin/bazel \
    && chmod +x /usr/bin/bazel 

# run as root for now
WORKDIR /home/admin/

ENTRYPOINT [ "/bin/bash", "-lc" ]
