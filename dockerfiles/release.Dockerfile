FROM centos:centos7

# GCC version
ARG DEVTOOLSET_VERSION=11

RUN yum install -y centos-release-scl epel-release \
    && yum clean all

# install devtools and [enable it](https://access.redhat.com/solutions/527703)
RUN yum install -y \
    devtoolset-${DEVTOOLSET_VERSION}-gcc \
    devtoolset-${DEVTOOLSET_VERSION}-gcc-c++ \
    devtoolset-${DEVTOOLSET_VERSION}-binutils \
    devtoolset-${DEVTOOLSET_VERSION}-libatomic-devel \
    devtoolset-${DEVTOOLSET_VERSION}-libasan-devel \
    devtoolset-${DEVTOOLSET_VERSION}-libubsan-devel \
    git vim-common wget unzip which java-11-openjdk-devel.x86_64 \
    libtool autoconf make cmake3 ninja-build lcov golang \
    && yum clean all \
    && echo "source scl_source enable devtoolset-${DEVTOOLSET_VERSION}" > /etc/profile.d/enable_gcc_toolset.sh \
    && ln -s /usr/bin/cmake3 /usr/bin/cmake

RUN wget --no-check-certificate https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.gz \
    && tar zxf nasm-2.15.05.tar.gz \
    && cd nasm-2.15.05 \
    && ./configure \
    && make install \
    && rm -rf nasm-2.15.05 \
    && rm -rf nasm-2.15.05.tar.gz

# install python3-devtools
RUN yum install -y rh-python38-python-devel.x86_64 rh-python38-python-pip.noarch \
    && yum clean all \
    && echo "source scl_source enable rh-python38" > /etc/profile.d/enable_py_toolset.sh

ENV PATH="/opt/rh/gcc-toolset-${DEVTOOLSET_VERSION}/root/usr/bin:${PATH}" 

# install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# install bazel 
RUN wget github.com/bazelbuild/bazel/releases/download/5.4.0/bazel-5.4.0-installer-linux-x86_64.sh \
    && bash ./bazel-5.4.0-installer-linux-x86_64.sh && rm -f ./bazel-5.4.0-installer-linux-x86_64.sh

# install python packages
RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install wheel numpy

# run as root for now
WORKDIR /home/admin/

CMD [ "/bin/bash" ]