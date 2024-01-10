# syntax=docker/dockerfile:1

FROM ubuntu:22.04

LABEL description="Image for running the Lune server"

# Install tools for CI
RUN apt-get update
RUN apt-get install -y unzip pkg-config build-essential curl

# Create user for use with Foreman tools
RUN useradd -m github-actions
USER github-actions
ENV HOME /home/github-actions

# Get Rust and add it to environment
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="${PATH}:$HOME/.cargo/bin"

RUN cargo install just

# Install Foreman and setup PATH for tool binaries
RUN cargo install foreman
ENV PATH="${PATH}:$HOME/.foreman/bin"

COPY . .
WORKDIR /

EXPOSE 8080

RUN just init
RUN just serve
