FROM centos:centos8

RUN cd /etc/yum.repos.d/ \
    && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
    && yum update -y \
    && yum install -y dnf-plugins-core \
    && yum config-manager --set-enabled powertools \
    && yum clean all

RUN yum install -y \
    git vim-common wget unzip which java-11-openjdk-devel \
    libtool autoconf make ninja-build \
    && yum clean all

# install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh \
    && bash Miniconda3-latest-Linux-aarch64.sh -b \
    && rm -f Miniconda3-latest-Linux-aarch64.sh \
    && /root/miniconda3/bin/conda init

# Install lld
RUN /root/miniconda3/bin/conda install -c conda-forge lld nasm cmake gxx==11.4.0 -y \
    && /root/miniconda3/bin/conda clean -afy

# install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# install go
ARG GO_VERSION=1.21.4
ARG GO_SHA256SUM=ce1983a7289856c3a918e1fd26d41e072cc39f928adfb11ba1896440849b95da

# install go
RUN url="https://golang.google.cn/dl/go${GO_VERSION}.linux-arm64.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${GO_SHA256SUM} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH="/usr/local"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

# install bazel 
RUN wget https://github.com/bazelbuild/bazelisk/releases/download/v1.19.0/bazelisk-linux-arm64 \
    && mv bazelisk-linux-arm64 /usr/bin/bazel \
    && chmod +x /usr/bin/bazel 

# Add conda to path
ENV PATH="/root/miniconda3/bin:${PATH}"

# run as root for now
WORKDIR /home/admin/

ENTRYPOINT [ "/bin/bash", "-l" ]
