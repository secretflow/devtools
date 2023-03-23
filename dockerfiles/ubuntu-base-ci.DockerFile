FROM ubuntu:jammy

LABEL maintainer="secretflow-contact@service.alipay.com"

# retrive apt info
RUN apt-get update

RUN apt-get install -y gcc-11 g++-11 libasan6 \
    git wget unzip autoconf make lld-15 \
    cmake ninja-build nasm vim-common \
    && apt-get clean \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11 \
    && ln -s /usr/bin/ld.lld-15 /usr/bin/ld.lld

# install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh \
    && bash Miniconda3-py38_23.1.0-1-Linux-x86_64.sh -b \
    && rm -f Miniconda3-py38_23.1.0-1-Linux-x86_64.sh \
    && /root/miniconda3/bin/conda init

# Add conda to path
ENV PATH="/root/miniconda3/bin:${PATH}" 

# This is due to a stupid bazel build https://github.com/bazelbuild/rules_python/issues/691
RUN ln -s /root/miniconda3/bin/python3 /usr/bin/python3

# install bazel 
RUN wget https://github.com/bazelbuild/bazel/releases/download/5.4.0/bazel-5.4.0-installer-linux-x86_64.sh \
    && bash ./bazel-5.4.0-installer-linux-x86_64.sh && rm -f ./bazel-5.4.0-installer-linux-x86_64.sh

# run as root for now
WORKDIR /home/admin/

CMD ["/bin/bash"]
