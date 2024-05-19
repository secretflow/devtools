FROM ubuntu:jammy

LABEL maintainer="secretflow-contact@service.alipay.com"

ARG TARGETPLATFORM

# change dash to bash as default shell
RUN ln -sf /bin/bash /bin/sh

RUN apt update \
    && apt upgrade -y \
    && apt install -y gcc-11 g++-11 libasan6 \
    git wget curl unzip autoconf make lld-15 \
    cmake ninja-build vim-common libgl1 libglib2.0-0 \
    && apt clean \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 \
    && update-alternatives --install /usr/bin/ld.lld ld.lld /usr/bin/ld.lld-15 100 

# clang is required on arm64 platform
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then apt install -y clang-15 \
    && apt clean \
    && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-15 100 \
    && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-15 100 \
; fi


# amd64 is only reqiured on amd64 platform
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] ; then apt install -y nasm ; fi

# install conda
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then CONDA_ARCH=aarch64 ; else CONDA_ARCH=x86_64 ; fi \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-py310_24.3.0-0-Linux-$CONDA_ARCH.sh \
    && bash Miniconda3-py310_24.3.0-0-Linux-$CONDA_ARCH.sh -b \
    && rm -f Miniconda3-py310_24.3.0-0-Linux-$CONDA_ARCH.sh \
    && /root/miniconda3/bin/conda init

# Add conda to path
ENV PATH="/root/miniconda3/bin:${PATH}" 

# install bazel 
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then BAZEL_ARCH=arm64 ; else BAZEL_ARCH=amd64 ; fi \
    && wget https://github.com/bazelbuild/bazelisk/releases/download/v1.20.0/bazelisk-linux-$BAZEL_ARCH \
    && mv bazelisk-linux-$BAZEL_ARCH /usr/bin/bazel \
    && chmod +x /usr/bin/bazel 

# run as root for now
WORKDIR /home/admin/

ENTRYPOINT [ "/bin/bash", "-lc" ]
