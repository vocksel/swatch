# syntax=docker/dockerfile:1

FROM rust:1.75.0 AS build-lune

ARG LUNE_VERSION

RUN apt-get update && apt-get install -y git gcc

# HACK: Need to install Lune from its main branch to bind servers to 0.0.0.0
RUN git clone https://github.com/lune-org/lune
RUN cargo build --release --manifest-path lune/Cargo.toml

# RUN curl -LJO https://github.com/lune-org/lune/releases/download/v${LUNE_VERSION}/lune-${LUNE_VERSION}-linux-aarch64.zip
# RUN unzip *.zip

FROM ubuntu:24.04 AS server

EXPOSE 8080
VOLUME [ "/app/server" ]
WORKDIR /app

# The server spawns processes for these commands
RUN apt-get update && apt-get install -y curl unzip

COPY --from=build-lune ./lune/target/release/lune /usr/local/bin
