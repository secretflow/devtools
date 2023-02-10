FROM secretflow/base-ci:0.1

# install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# run as root for now
WORKDIR /home/admin/

CMD ["/bin/bash"]
