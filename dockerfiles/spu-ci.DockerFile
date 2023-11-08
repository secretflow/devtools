# Base image contains c++ toolchain and python
# These should be consistant across all Secretflow dockers
FROM secretflow/ubuntu-base-ci:latest

ARG TARGETPLATFORM
