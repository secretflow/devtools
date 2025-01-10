FROM ubuntu:jammy

LABEL maintainer="secretflow-contact@service.alipay.com"

# change dash to bash as default shell
RUN ln -sf /usr/bin/bash /bin/sh

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y wget gnupg2 software-properties-common \
    && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && add-apt-repository "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-19 main" \
    && apt-get update -y \
    && apt-get install -y clang-format-19 git openssh-client curl python3-pip \
    && apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh \
    && sh nodesource_setup.sh \
    && rm -f nodesource_setup.sh \
    && apt-get install -y nodejs \
    && apt-get clean

RUN npm install markdownlint-cli2 --global \
    && rm -rf node_modules

RUN pip install rstcheck[sphinx,toml]

RUN ln -sf /usr/bin/clang-format-19 /usr/bin/clang-format

# run as root for now
WORKDIR /home/admin/

ENTRYPOINT [ "/bin/bash", "-l" ]
