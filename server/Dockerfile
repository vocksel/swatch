# syntax=docker/dockerfile:1

FROM ubuntu:24.04

LABEL description="Image for running the Lune server"

EXPOSE 8080

ARG LUNE_VERSION

RUN apt-get update
RUN apt-get install -y \
	build-essential \
	curl \
	unzip

COPY ./server/src /server
WORKDIR /server

# HACK: Need to install a forked Lune that binds servers to 0.0.0.0
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN apt-get install -y git gcc
RUN git clone --single-branch --branch serve-from-other-ips https://github.com/vocksel/lune
RUN cargo build --release --manifest-path lune/Cargo.toml
CMD [ "./lune/target/release/lune", "run", "server.luau" ]

# RUN curl -LJO https://github.com/lune-org/lune/releases/download/v${LUNE_VERSION}/lune-${LUNE_VERSION}-linux-aarch64.zip
# RUN unzip *.zip

# CMD [ "./lune", "server.luau" ]
