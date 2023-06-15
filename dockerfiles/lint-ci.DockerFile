FROM ubuntu:jammy

LABEL maintainer="secretflow-contact@service.alipay.com"

# change dash to bash as default shell
RUN ln -sf /usr/bin/bash /bin/sh

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y clang-format-15 git openssh-client curl python3-pip \
    && apt-get clean 

RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh \
    && sh nodesource_setup.sh \
    && rm -f nodesource_setup.sh \
    && apt-get install -y nodejs \
    && apt-get clean 

RUN npm install markdownlint-cli2 --global \
    && rm -rf node_modules

RUN pip install rstcheck[sphinx,toml]

RUN ln -sf /usr/bin/clang-format-15 /usr/bin/clang-format

# run as root for now
WORKDIR /home/admin/

ENTRYPOINT [ "/bin/bash", "-l" ]
