# Base image contains c++ toolchain and python
# These should be consistant across all Secretflow dockers
FROM secretflow/base-ci:0.2

# install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

