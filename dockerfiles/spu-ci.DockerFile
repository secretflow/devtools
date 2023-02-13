# Base image contains c++ toolchain and python
# These should be consistant across all Secretflow dockers
FROM secretflow/base-ci:0.1

# Required by grpc
RUN yum install -y golang \
    && yum clean all
