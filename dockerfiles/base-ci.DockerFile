FROM openanolis/anolisos:8.6-x86_64

LABEL maintainer="secretflow-contact@service.alipay.com"

# GCC version
ARG DEVTOOLSET_VERSION=11

RUN yum makecache

# install devtools and [enable it](https://access.redhat.com/solutions/527703)
RUN yum install -y \
    gcc-toolset-${DEVTOOLSET_VERSION}-gcc \
    gcc-toolset-${DEVTOOLSET_VERSION}-gcc-c++ \
    gcc-toolset-${DEVTOOLSET_VERSION}-binutils \
    gcc-toolset-${DEVTOOLSET_VERSION}-libatomic-devel \
    gcc-toolset-${DEVTOOLSET_VERSION}-libasan-devel \
    gcc-toolset-${DEVTOOLSET_VERSION}-libubsan-devel \
    git wget unzip which libtool autoconf make \
    cmake ninja-build nasm vim-common java-11-openjdk-devel \
    && echo "source scl_source enable gcc-toolset-${DEVTOOLSET_VERSION}" > /etc/profile.d/enable_gcc_toolset.sh \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && yum clean all

# Add gcc to path
ENV PATH="/opt/rh/gcc-toolset-${DEVTOOLSET_VERSION}/root/usr/bin:${PATH}" 

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
