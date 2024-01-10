# syntax=docker/dockerfile:1

FROM ubuntu:24.04

LABEL description="Image for running the Lune server"

ARG GITHUB_TOKEN

# Install tools for CI
RUN apt-get update
RUN apt-get install -y \
	build-essential \
	curl \
	libssl-dev \
	pkg-config \
	unzip

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
RUN foreman github-auth ${GITHUB_TOKEN}
RUN foreman install

COPY . /server
WORKDIR /server

EXPOSE 8080

CMD [ "just", "serve" ]
