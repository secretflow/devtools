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
    cmake ninja-build nasm python38 python38-devel vim-common java-11-openjdk-devel golang \
    && echo "source scl_source enable gcc-toolset-${DEVTOOLSET_VERSION}" > /etc/profile.d/enable_gcc_toolset.sh \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && yum clean all

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# install bazel 
RUN wget github.com/bazelbuild/bazel/releases/download/5.4.0/bazel-5.4.0-installer-linux-x86_64.sh \
    && bash ./bazel-5.4.0-installer-linux-x86_64.sh && rm -f ./bazel-5.4.0-installer-linux-x86_64.sh

# run as root for now
WORKDIR /home/admin/

CMD ["/bin/bash"]
